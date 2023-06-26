import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../styles/size.dart';
import 'delete_dialog.dart';
import 'edit_dialog.dart';
import 'edit_image_dialog.dart';


class ListPopupMenu extends StatelessWidget {
  const ListPopupMenu({super.key, required this.list});

  final LinksList list;

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
              const Icon(Icons.image),
              SizedBox(width: AppSizes.small),
              const Text("Edit list image")
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
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
          showDialog(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return DeleteListDialog(list: list);
            },
          );
        } else if (value == 2) {
          showDialog(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return EditListDialog(list: list);
            },
          );
        } else if (value == 3) {
          showDialog(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return EditListImageDialog(list: list);
            },
          );
        }
      },
    );
  }
}