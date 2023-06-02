import 'package:flutter/material.dart';
import 'package:links_app/widgets/list/popup_menu.dart';

import '../../model/list.dart';
import '../../pages/list.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.list});
  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(list.name),
          trailing: ListPopupMenu(list: list),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPage(list: list)),
            );
          }),
    );
  }
}
