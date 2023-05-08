import 'package:flutter/material.dart';

import '../model/enums.dart';
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
        trailing: ListPopupMenu(list: list),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListPage(list: list)),
          );
        }
      ),
    );
  }
}

class ListPopupMenu extends StatelessWidget {
  const ListPopupMenu({super.key, required this.list});

  final LinksList list;

  Future<ConfirmAction?> _deleteList(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog! 
      builder: (BuildContext context) {
        return AlertDialog(  
          title: const Text("Delete this list?"),
          content: const Text("This will delete the list with all its links."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                ListProvider.deleteList(list.id);
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(
                width: 10,
              ),
              Text("Delete list")
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: const [
              Icon(Icons.edit),
              SizedBox(
                width: 10,
              ),
              Text("Edit list name")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: const [
              Icon(Icons.close),
              SizedBox(
                width: 10,
              ),
              Text("Cancel")
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 1) {
          final ConfirmAction? action = await _deleteList(context);
          print(action);
        } else if (value == 2) {
          //_editList(context);
        }
      },
    );
  }
}

