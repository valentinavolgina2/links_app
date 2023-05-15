import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../providers/link.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/forms/helper.dart';
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
            constraints: FormHelpers.formMaxWidthConstraints(),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.medium),
              child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Adding new link', style: TextStyle(fontSize: AppSizes.textTitle)),
                      SizedBox(height: AppSizes.medium),
                      const Text('Name'),
                      SizedBox(height: AppSizes.small),
                      TextField(
                        controller: _linkNameController,
                        decoration: FormHelpers.inputDecoration(hintText: 'Name'),
                      ),
                      SizedBox(height: AppSizes.medium),
                      const Text('Url'),
                      SizedBox(height: AppSizes.small),
                      TextField(
                        controller: _linkUrlController,
                        decoration: FormHelpers.inputDecoration(hintText: 'Url'),
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
                              child: FormHelpers.saveButton(),
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
              padding: EdgeInsets.all(AppSizes.small),
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
