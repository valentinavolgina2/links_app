import 'package:flutter/material.dart';

import '../styles/color.dart';
import '../styles/size.dart';
import 'link.dart';

class LinksList {
  String name;
  List<Link> links;
  List<LinksList> lists;

  LinksList({required this.name, this.links = const [], this.lists = const []});

  final TextStyle titleStyle = TextStyle(color: AppColors.category.text, fontSize: AppSizes.category.text);

  Widget buildList(BuildContext context, {bool withName = true}) {
    List<Widget> items =
        links.map((link) => link.buildLink(context)).toList(); // links
    items.addAll(
        lists.map((list) => list.buildList(context)).toList()); // sublists

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
      title: (withName) ? Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          name,
          style: titleStyle
        ),
      ) : const SizedBox.shrink(),
      subtitle: ListView(
          shrinkWrap: true,
          children: items
      ),
    );
  }
}
