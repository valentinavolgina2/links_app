import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const MyAppBar()
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: ListContainer(list: list, withName: false),
            )
          ),
        );
      })
    );
  }
}
