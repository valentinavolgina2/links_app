import 'package:flutter/material.dart';

import '../model/list.dart';
import '../pages/list/show.dart';
import '../providers/list.dart';
import '../styles/color.dart';
import '../styles/size.dart';
import 'forms/helper.dart';
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
            constraints: FormHelpers.formMaxWidthConstraints(),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.medium),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Editing ${list.name}', style: TextStyle(fontSize: AppSizes.textTitle)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Name'),
                    SizedBox(height: AppSizes.small),
                    TextField(
                      controller: editListController,
                      decoration: FormHelpers.inputDecoration(hintText: 'Name'),
                    ),
                    SizedBox(height: AppSizes.medium),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
                              child: FilledButton(
                                style: FilledButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: FormHelpers.cancelButton(),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
                              child: FilledButton(
                                onPressed: () {
                                  ListProvider.updateList(list: list, newName: editListController.text);
                                  Navigator.of(context).pop();

                                  SystemMessage.showSuccess(
                                      context: context, message: 'The changes were saved.');
                                },
                                child: FormHelpers.saveButton(),
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
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.delete),
              SizedBox(width: AppSizes.small),
              const Text("Delete list")
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.edit),
              SizedBox(width: AppSizes.small),
              const Text("Edit list name")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              const Icon(Icons.close),
              SizedBox(width: AppSizes.small),
              const Text("Cancel")
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
