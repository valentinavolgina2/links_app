import 'package:flutter/material.dart';

import '../model/list.dart';
import '../styles/size.dart';
import '../widgets/app_bar/app_bar.dart';
import '../widgets/app_bar/helper.dart';
import '../widgets/link/add_dialog.dart';
import '../widgets/list/list.dart';
import '../widgets/responsive.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key, required this.list});

  final LinksList list;
  final ValueNotifier<List<String>> _listTags = ValueNotifier([]);
  final ValueNotifier<List<String>> _listCategories = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? smallScreenAppBar()
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: const MyAppBar()),
      drawer: const MyDrawer(),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(AppSizes.small, AppSizes.small, AppSizes.small, AppSizes.large),
              child: ListContainer(list: list, withName: false, allTags: _listTags, allCategories: _listCategories,)),
        );
      }),
      floatingActionButton: FloatingActionButton(

          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return LinkAddDialog(
                  list: list,
                  listTags: _listTags.value,
                  listCategories: _listCategories.value
                );
              }
            );
          },
          tooltip: 'Add new link',
          child: const Icon(Icons.add)),
    );
  }
}
