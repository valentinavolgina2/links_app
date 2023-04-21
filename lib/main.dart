import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import 'model/lists.dart';
import 'widgets/listCard.dart';

void main() {
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
          child: ListView(
              children:
                  myLists.map((list) => ListCard(list: list)).toList(),
          )
      )
    );
  }
}
