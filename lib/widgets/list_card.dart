import 'package:flutter/material.dart';

import '../model/list.dart';
import '../pages/list/show.dart';
import '../providers/list.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.list});
  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(list.name),
          trailing: IconButton(
            onPressed: () => ListProvider.deleteList(list.id),
            icon: const Icon(Icons.delete),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPage(list: list)),
            );
          }),
    );
  }
}
