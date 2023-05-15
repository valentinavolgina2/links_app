import 'dart:async';

import 'package:flutter/material.dart';
import 'package:links_app/connection/database.dart';
import 'package:links_app/providers/list.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';
import 'package:links_app/widgets/app_bar.dart';
import 'package:links_app/widgets/forms/utils.dart';
import 'package:links_app/widgets/list_card.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:links_app/widgets/message.dart';

import 'connection/authentication.dart';
import 'model/app.dart';
import 'model/list.dart';

Future<void> main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  await DB.connect();

  await getUser();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppData.title,
      theme: ThemeData(
        primarySwatch: AppColors.primaryColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LinksList> myLists = [];

  late StreamSubscription<DatabaseEvent> _listsSubscription;
  late StreamSubscription<DatabaseEvent> _listsDeleteSubscription;
  late StreamSubscription<DatabaseEvent> _listsChangeSubscription;

  late DatabaseReference _listsRef;

  late TextEditingController addListController;

  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    DB.enableLogging(false);

    addListController = TextEditingController();

    _listsRef = ListProvider.userlistsRef(userId: uid);

    _listsSubscription = _listsRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          myLists.insert(0,
              LinksList.fromSnapshot(snapshot: event.snapshot, userId: uid!));
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );

    _listsDeleteSubscription = _listsRef.onChildRemoved.listen(
      (DatabaseEvent event) {
        setState(() {
          final listToRemove =
              myLists.where((list) => list.id == event.snapshot.key).first;
          myLists.remove(listToRemove);
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );

    _listsChangeSubscription = _listsRef.onChildChanged.listen(
      (DatabaseEvent event) {
        setState(() {
          final listToChange =
              myLists.where((list) => list.id == event.snapshot.key).first;
          listToChange.name = event.snapshot.value.toString();
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
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

  void _addList(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: FormUtils.formMaxWidthConstraints(),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.medium),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Adding new list', style: TextStyle(fontSize: AppSizes.textTitle)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Name'),
                    SizedBox(height: AppSizes.small),
                    TextField(
                      controller: addListController,
                      decoration: FormUtils.inputDecoration(hintText: 'Name'),
                    ),
                    SizedBox(height: AppSizes.medium),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: FormUtils.cancelButton(),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
                            child: FilledButton(
                              onPressed: () {
                                ListProvider.addList(
                                    name: addListController.text, userId: uid!);

                                Navigator.of(context).pop();

                                SystemMessage.showSuccess(
                                    context: context,
                                    message: 'List ${addListController.text} was added.');

                                addListController.clear();
                              },
                              child: FormUtils.saveButton(),
                            ),
                          ),
                        ),
                      ])
                  ],
                    
                  )),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000), child: const MyAppBar()),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(AppSizes.small),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( 
                  child: ListView(
                      children:
                          myLists.map((list) => ListCard(list: list)).toList()),
                ),
              ],
            ),
          ),
        ),
      )),
      floatingActionButton: uid == null
          ? null
          : FloatingActionButton(
              onPressed: () => _addList(context),
              tooltip: 'Add new list',
              child: const Icon(Icons.add)),
    );
  }
}
