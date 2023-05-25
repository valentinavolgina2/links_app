import 'dart:async';

import 'package:flutter/material.dart';
import 'package:links_app/connection/database.dart';
import 'package:links_app/providers/list.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';
import 'package:links_app/widgets/app_bar.dart';
import 'package:links_app/widgets/forms/helper.dart';
import 'package:links_app/widgets/list_card.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:links_app/widgets/no_content.dart';
import 'package:links_app/widgets/responsive.dart';

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

  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    DB.enableLogging(false);

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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final TextStyle titleStyle =
        TextStyle(color: AppColors.darkText, fontSize: AppSizes.textTitle);

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
      ? AppBar( // for smaller screen sizes
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Text(
            AppData.title.toUpperCase(),
            style: TextStyle(
              color: AppColors.secondaryFade,
              fontSize: AppSizes.textTitle,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        )
      : PreferredSize(
          preferredSize: Size(screenSize.width, 1000), child: const MyAppBar()
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  stops: const [0.4, 0.8],
                ),
              ),
            child: Padding(
                  padding: EdgeInsets.all(AppSizes.small),
                  child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
              child: uid == null 
              ? EmptyContainer.needLogin(context)
              : myLists.isEmpty
                ? EmptyContainer.noListsAdded(context: context, userId: uid!)
                : ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.medium, horizontal: AppSizes.small),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('My lists',
                                style: TextStyle(
                                    fontSize: titleStyle.fontSize))),
                        ElevatedButton(
                              onPressed: () => FormHelpers.addList(context: context, userId: uid!), 
                              child: const Text('New list')
                            ),
                      ],
                    ),
                  ),
                  subtitle: ListView(
                      children: myLists.map((list) => ListCard(list: list)).toList(),
                    ),
                )
            ),
                  ),
                ),
          )),
    );
  }
}
