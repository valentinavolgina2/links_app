import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/link.dart';
import '../providers/link.dart';
import '../styles/color.dart';
import 'forms/utils.dart';
import 'message.dart';

class LinkContainer extends StatelessWidget {
  const LinkContainer({super.key, required this.link});

  final Link link;

  _launchURL(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
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
          onTap: () async {
            await _launchURL(Uri.encodeFull(link.url));
          }),
    );
  }
}

class LinkPopupMenu extends StatelessWidget {
  LinkPopupMenu({super.key, required this.link});

  final Link link;

  final TextEditingController editLinkNameController = TextEditingController();
  final TextEditingController editLinkUrlController = TextEditingController();

  void _deleteLink(BuildContext context) {
    showDialog(
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
      },
    );
  }

  void _editLink(BuildContext context) {
    editLinkNameController.text = link.name;
    editLinkUrlController.text = link.url;

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
                    Text('Editing ${link.name}', style: const TextStyle(fontSize: 20.0)),
                    const SizedBox(height: 20.0),
                    const Text('Name'),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: editLinkNameController,
                      decoration: FormUtils.inputDecoration(hintText: 'Name'),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Url'),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: editLinkUrlController,
                      decoration: FormUtils.inputDecoration(hintText: 'Url'),
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
                                  LinkProvider.updateLink(
                                      link: link,
                                      newName: editLinkNameController.text,
                                      newUrl: editLinkUrlController.text);
                                  Navigator.of(context).pop();
            
                                  SystemMessage.showSuccess(
                                      context: context, message: 'The changes were saved.');
                                },
                                child: FormUtils.saveButton(),
                              ),
                            ),
                          ),
                        ])
                  ])),
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
              Text("Delete link")
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
              Text("Edit link")
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
          _deleteLink(context);
        } else if (value == 2) {
          _editLink(context);
        }
      },
    );
  }
}
