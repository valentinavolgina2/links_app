import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../providers/link.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/forms/utils.dart';
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
                      const Text('Adding new link', style: TextStyle(fontSize: 20.0)),
                      const SizedBox(height: 20.0),
                      const Text('Name'),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _linkNameController,
                        decoration: FormUtils.inputDecoration(hintText: 'Name'),
                      ),
                      const SizedBox(height: 20.0),
                      const Text('Url'),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _linkUrlController,
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
                                LinkProvider.addLink(
                                  name: _linkNameController.text,
                                  url: _linkUrlController.text,
                                  listId: list.id);

                                Navigator.of(context).pop();

                                SystemMessage.showSuccess(
                                    context: context, message: 'Link was added.');

                                _linkNameController.clear();
                                _linkUrlController.clear();
                              },
                              child: FormUtils.saveButton(),
                            ),
                          ),
                        ),
                      ])
                    ]
                  )),
            ),
          ),
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
