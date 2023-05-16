import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../styles/size.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/forms/helper.dart';
import '../../widgets/list.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000), child: const MyAppBar()),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
              padding: EdgeInsets.all(AppSizes.small),
              child: ListContainer(list: list, withName: false)),
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => FormHelpers.addLink(context: context, list: list),
          tooltip: 'Add new link',
          child: const Icon(Icons.add)),
    );
  }
}
