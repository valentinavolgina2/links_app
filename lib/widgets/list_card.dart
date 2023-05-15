import 'package:flutter/material.dart';

import '../model/list.dart';
import '../pages/list/show.dart';
import '../providers/list.dart';
import 'forms/utils.dart';
import 'message.dart';

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

class ListPopupMenu extends StatelessWidget {
  ListPopupMenu({super.key, required this.list});

  final LinksList list;

  final TextEditingController editListController = TextEditingController();

  void _deleteList(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this list?'),
          content: Text(
              'This will delete the list ${list.name} with all its links.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ListProvider.deleteList(list);
                Navigator.of(context).pop();

                SystemMessage.showSuccess(
                    context: context,
                    message: 'The list ${list.name} was deleted.');
              },
            ),
          ],
        );
      },
    );
  }

  void _editList(BuildContext context) {
    editListController.text = list.name;

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: FormUtils.formMaxWidthConstraints(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Editing ${list.name}', style: const TextStyle(fontSize: 20.0)),
                    const SizedBox(height: 20.0),
                    const Text('Name'),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: editListController,
                      decoration: FormUtils.inputDecoration(hintText: 'Name'),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: FormUtils.cancelButton(),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: FilledButton(
                                onPressed: () {
                                  ListProvider.updateList(list: list, newName: editListController.text);
                                  Navigator.of(context).pop();

                                  SystemMessage.showSuccess(
                                      context: context, message: 'The changes were saved.');
                                },
                                child: FormUtils.saveButton(),
                              ),
                            ),
                          ),
                        ])
                  ],
                )
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(
                width: 10,
              ),
              Text("Delete list")
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(
                width: 10,
              ),
              Text("Edit list name")
            ],
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Row(
            children: [
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
          _deleteList(context);
        } else if (value == 2) {
          _editList(context);
        }
      },
    );
  }
}
