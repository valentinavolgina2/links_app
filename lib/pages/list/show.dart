import 'package:flutter/material.dart';

import '../../model/app.dart';
import '../../model/list.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/forms/helper.dart';
import '../../widgets/list.dart';
import '../../widgets/responsive.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key, required this.list});

  final LinksList list;
  final ValueNotifier<List<String>> _listTags = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              // for smaller screen sizes
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
              preferredSize: Size(screenSize.width, 1000),
              child: const MyAppBar()),
      drawer: const MyDrawer(),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
              padding: EdgeInsets.all(AppSizes.small),
              child: ListContainer(list: list, withName: false, allTags: _listTags)),
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => FormHelpers.addLink(context: context, list: list, listTags: _listTags.value),
          tooltip: 'Add new link',
          child: const Icon(Icons.add)),
    );
  }
}
