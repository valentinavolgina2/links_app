import 'package:flutter/material.dart';
import 'package:links_app/model/list.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../providers/list.dart';
import '../../styles/size.dart';
import '../message.dart';

class ListUpdateButton extends StatelessWidget {
  const ListUpdateButton({
    super.key, 
    required this.list, 
    required this.formKey, 
    required this.editNameController
  });

  final LinksList list;
  final GlobalKey<FormState> formKey;
  final TextEditingController editNameController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
        child: FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ListProvider.updateList(
                  list: list, newName: editNameController.text);
              Navigator.of(context).pop();

              SystemMessage.showSuccess(
                  context: context, message: 'The changes were saved.');
            }
          },
          child: const SaveButton(),
        ),
      ),
    );
  }
}
