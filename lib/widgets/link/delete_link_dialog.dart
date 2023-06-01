import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../providers/link.dart';
import '../message.dart';

class DeleteLinkDialog extends StatelessWidget {
  const DeleteLinkDialog({super.key, required this.link});

  final Link link;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete this link?'),
      content: Text('This will delete link ${link.name}.'),
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
            LinkProvider.deleteLink(link);
            Navigator.of(context).pop();

            SystemMessage.showSuccess(
                context: context,
                message: 'The link ${link.name} was deleted.');
          },
        ),
      ],
    );
  }
}
