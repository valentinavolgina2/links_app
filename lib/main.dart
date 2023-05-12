import 'dart:async';

import 'package:flutter/material.dart';
import 'package:links_app/connection/database.dart';
import 'package:links_app/providers/list.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/auth_dialog.dart';
import 'package:links_app/widgets/list_card.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:links_app/widgets/message.dart';

import 'connection/authentication.dart';
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
  late StreamSubscription<DatabaseEvent> _listsChangeSubscription;

  late TextEditingController addListController;

  bool _isProcessing = false;

  @override
  void initState() {
    init();
    getUserInfo();
    super.initState();
  }

  Future getUserInfo() async {
    await getUser();
    setState(() {});
    //print(uid);
  }

  Future<void> init() async {
    DB.enableLogging(false);

    addListController = TextEditingController();

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

    _listsChangeSubscription = ListProvider.listsRef.onChildChanged.listen(
      (DatabaseEvent event) {
        setState(() {
          final listToChange =
              myLists.where((list) => list.id == event.snapshot.key).first;
          listToChange.name = event.snapshot.value.toString();
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
    _listsChangeSubscription.cancel();
  }

  void _addList() {
    ListProvider.addList(addListController.text);
    addListController.clear();
  }

  _signout() async {
    setState(() {
      _isProcessing = true;
    });

    await signOut().then((result) {
      SystemMessage.showSuccess(
          context: context, message: 'You have signed out successfully.');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => MyHomePage(title: 'My lists'),
        ),
      );
    }).catchError((error) {
      SystemMessage.showError(
          context: context, message: 'Sign Out Error: $error');
    });

    setState(() {
      _isProcessing = false;
    });
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
            ElevatedButton(
                onPressed: userEmail == null
                    ? () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AuthDialog(),
                        );

                        setState(() {});
                      }
                    : null,
                child: userEmail == null
                    ? const Text('Sign in')
                    : Row(children: [
                        Text(userEmail!,
                            style: const TextStyle(
                              color: Colors.white70,
                            )),
                        const SizedBox(width: 20.0),
                        TextButton(
                            onPressed: _isProcessing ? null : () => _signout(),
                            child: _isProcessing
                                ? const CircularProgressIndicator()
                                : const Text('Sign out'))
                      ])),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
              child: TextField(
                controller: addListController,
                maxLength: 100,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0)),
                  hintText: 'New list name',
                  contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  suffixIcon: ElevatedButton(
                      onPressed: _addList, child: const Text('Add')),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                  children:
                      myLists.map((list) => ListCard(list: list)).toList()),
            ),
          ],
        ),
      )),
    );
  }
}
