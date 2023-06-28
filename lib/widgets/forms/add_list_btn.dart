import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../connection/authentication.dart';
import '../../providers/list.dart';
import '../../styles/size.dart';
import '../message.dart';

class ListAddButton extends StatelessWidget {
  const ListAddButton(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.imgNotifier});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final ValueNotifier<XFile?> imgNotifier;

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
              ListProvider.addList(
                  name: nameController.text, userId: uid!, img: imgNotifier.value);

              Navigator.of(context).pop();

              SystemMessage.showSuccess(
                  context: context,
                  message: 'List ${nameController.text} was added.');

              nameController.clear();
            }
          },
          child: const SaveButton(),
        ),
      ),
    );
  }
}
