import 'dart:async';

import 'package:flutter/material.dart';
import 'package:links_app/connection/database.dart';
import 'package:links_app/providers/list.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/list_card.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_core/firebase_core.dart';

import 'model/list.dart';

Future<void> main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  await DB.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Links App',
      theme: ThemeData(
        primarySwatch: AppColors.scaffold.primary,
      ),
      home: const MyHomePage(title: 'My lists'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LinksList> myLists = [];

  late StreamSubscription<DatabaseEvent> _listsSubscription;
  late StreamSubscription<DatabaseEvent> _listsDeleteSubscription;

  TextEditingController addListController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    DB.enableLogging(false);

    _listsSubscription = ListProvider.listsRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          myLists.insert(0, LinksList.fromSnapshot(event.snapshot));
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );

    _listsDeleteSubscription = ListProvider.listsRef.onChildRemoved.listen(
      (DatabaseEvent event) {
        setState(() {
          final listToRemove =
              myLists.where((list) => list.id == event.snapshot.key).first;
          myLists.remove(listToRemove);
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listsSubscription.cancel();
    _listsDeleteSubscription.cancel();
  }

  void _addList() {
    ListProvider.addList(addListController.text);
    addListController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                child: TextField(
                  controller: addListController,
                  maxLength: 100,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    hintText: 'New list name',
                    contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    suffixIcon: ElevatedButton(
                        onPressed: _addList,
                        child: const Text('Add')),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                    children: myLists.map((list) => ListCard(list: list)).toList()),
              ),
            ],
          ),
        )
      ),
    );
  }
}
