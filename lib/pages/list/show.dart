import 'package:flutter/material.dart';

import '../../model/list.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: list.buildList(context, withName: false),
            )
          ),
        );
      })
    );
  }
}
