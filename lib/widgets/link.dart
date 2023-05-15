import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/link.dart';
import '../providers/link.dart';
import '../styles/color.dart';
import '../styles/size.dart';
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
    final TextStyle textStyle = TextStyle(color: AppColors.darkText);

    return Card(
      color: AppColors.pinkBackground,
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
              padding: EdgeInsets.all(AppSizes.medium),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Editing ${link.name}', style: TextStyle(fontSize: AppSizes.textTitle)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Name'),
                    SizedBox(height: AppSizes.small),
                    TextField(
                      controller: editLinkNameController,
                      decoration: FormUtils.inputDecoration(hintText: 'Name'),
                    ),
                    SizedBox(height: AppSizes.medium),
                    const Text('Url'),
                    SizedBox(height: AppSizes.small),
                    TextField(
                      controller: editLinkUrlController,
                      decoration: FormUtils.inputDecoration(hintText: 'Url'),
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
                              padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
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
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.delete),
              SizedBox(width: AppSizes.small),
              const Text("Delete link")
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
              const Icon(Icons.close),
              SizedBox(width: AppSizes.small),
              const Text("Cancel")
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
