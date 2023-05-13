import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../model/list.dart';
import '../../providers/link.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list.dart';
import '../../widgets/message.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key, required this.list});

  final LinksList list;

  final TextEditingController _linkNameController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();

  _addLink(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adding new link'),
          content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _linkNameController,
                  ),
                  TextField(
                    controller: _linkUrlController,
                  )
                ]
              )),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                LinkProvider.addLink(Link(
                  name: _linkNameController.text,
                  url: _linkUrlController.text,
                  listId: list.id));

                Navigator.of(context).pop();

                SystemMessage.showSuccess(
                    context: context, message: 'Link was added.');

                _linkNameController.clear();
                _linkUrlController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000), child: const MyAppBar()),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: ListContainer(list: list, withName: false),
              )),
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addLink(context),
          tooltip: 'Add new link',
          child: const Icon(Icons.add)),
    );
  }
}
