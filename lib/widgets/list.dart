import 'package:flutter/material.dart';

import '../model/list.dart';
import '../styles/color.dart';
import '../styles/size.dart';
import 'link.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({super.key, required this.list, this.withName = true});

  final LinksList list;
  final bool withName;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      color: AppColors.category.text, fontSize: AppSizes.category.text);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
      title: (withName)
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(list.name, style: titleStyle),
            )
          : const SizedBox.shrink(),
      subtitle: ListView(
        shrinkWrap: true, 
        children: <Widget>[
          ...list.links.map((link) => LinkContainer(link: link)).toList(),
          ...list.lists.map((list) => ListContainer(list: list)).toList(),
        ]),
    );
  }
}
