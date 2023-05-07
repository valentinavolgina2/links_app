import 'dart:async';

import 'package:flutter/material.dart';
import 'package:links_app/connection/database.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/list_card.dart';
import 'package:flutter/widgets.dart';
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
  late DatabaseReference _listsRef;
  late StreamSubscription<DatabaseEvent> _listsSubscription;
  FirebaseException? _error;
  bool initialized = false;
  int _id = 0;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    DB.enableLogging(false);

    setState(() {
      initialized = true;
    });

    _listsRef = FirebaseDatabase.instance.ref('mylists');

    _listsSubscription = _listsRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          myLists.add(LinksList.fromSnapshot(event.snapshot));
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
  }

  Future<void> _addList() async {
    final listName = 'List $_id';
    final DatabaseReference newList =
        FirebaseDatabase.instance.ref('mylists/$listName').push();

    await newList.parent!.set(true);

    // final DatabaseReference newLinks =
    //     FirebaseDatabase.instance.ref('links/$listName').push();
    // await newLinks.parent!.set({'name': 'Name $_id', 'url': 'url $_id'});

    // await newLinks.parent!.set([{}, {}]);

    _id++;
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: ListView(
              children: myLists.map((list) => ListCard(list: list)).toList())),
      floatingActionButton: FloatingActionButton(
        onPressed: _addList,
        tooltip: 'Add new list',
        child: const Icon(Icons.add),
      ),
    );
  }
}
