import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../providers/link.dart';
import '../../styles/size.dart';
import 'delete_link_dialog.dart';
import 'edit_link_dialog.dart';

class LinkPopupMenu extends StatelessWidget {
  const LinkPopupMenu(
      {super.key,
      required this.link,
      required this.listTags,
      required this.listCategories});

  final Link link;
  final List<String> listTags;
  final List<String> listCategories;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.done),
              SizedBox(width: AppSizes.small),
              link.completed
                  ? const Text("Mark as not done")
                  : const Text("Mark as done")
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.edit),
              SizedBox(width: AppSizes.small),
              const Text("Edit link")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              const Icon(Icons.delete),
              SizedBox(width: AppSizes.small),
              const Text("Delete link")
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
          LinkProvider.complete(link: link, completed: !link.completed);
        } else if (value == 2) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return EditLinkDialog(link: link, listTags: listTags, listCategories: listCategories);
            }
          );
        } else if (value == 3) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return DeleteLinkDialog(link: link);
            }
          );
        }
      },
    );
  }
}
