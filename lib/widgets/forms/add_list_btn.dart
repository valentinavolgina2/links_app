import 'package:flutter/material.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../connection/authentication.dart';
import '../../providers/list.dart';
import '../../styles/size.dart';
import '../message.dart';

class ListAddButton extends StatelessWidget {
  const ListAddButton({
    super.key,
    required this.formKey, 
    required this.nameController
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
            left: AppSizes.small,
            right: AppSizes.small),
        child: FilledButton(
          onPressed: () {
            if (formKey.currentState!
                .validate()) {
              ListProvider.addList(
                  name: nameController.text,
                  userId: uid!);

              Navigator.of(context).pop();

              SystemMessage.showSuccess(
                  context: context,
                  message:
                      'List ${nameController.text} was added.');

              nameController.clear();
            }
          },
          child: const SaveButton(),
        ),
      ),
    );
  }
}