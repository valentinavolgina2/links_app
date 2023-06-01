import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../providers/list.dart';
import '../message.dart';

class DeleteListDialog extends StatelessWidget {
  const DeleteListDialog({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete this list?'),
      content:
          Text('This will delete the list ${list.name} with all its links.'),
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
  }
}
