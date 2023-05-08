import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/enums.dart';
import '../model/link.dart';
import '../providers/link.dart';
import '../styles/color.dart';
import 'message.dart';

class LinkContainer extends StatelessWidget {
  const LinkContainer({super.key, required this.link});

  final Link link;

  _launchURL(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(color: AppColors.link.text);

    return Card(
      color: AppColors.link.background,
      child: ListTile(
          title: Text(
            link.name,
            style: textStyle,
          ),
          trailing: LinkPopupMenu(link: link),
          onTap: () {
            _launchURL(Uri.encodeFull(link.url));
          }),
    );
  }
}

class LinkPopupMenu extends StatelessWidget {
  const LinkPopupMenu({super.key, required this.link});

  final Link link;

  Future<ConfirmAction?> _deleteLink(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this link?'),
          content: Text('This will delete link ${link.name}.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                LinkProvider.deleteLink(link);
                Navigator.of(context).pop(ConfirmAction.Accept);

                SystemMessage.showSuccess(context: context, message: 'The link ${link.name} was deleted.');
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
              Text("Delete link")
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
              Text("Edit link")
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
          final ConfirmAction? action = await _deleteLink(context);
          print(action);
        } else if (value == 2) {
          //_editList(context);
        }
      },
    );
  }
}
