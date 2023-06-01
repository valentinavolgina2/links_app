import 'package:flutter/material.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../model/link.dart';
import '../../providers/link.dart';
import '../../styles/size.dart';
import '../message.dart';

class LinkUpdateButton extends StatelessWidget {
  const LinkUpdateButton(
      {super.key,
      required this.link,
      required this.formKey,
      required this.nameController,
      required this.urlController,
      required this.tags,
      required this.selectedCategory});

  final Link link;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController urlController;
  final ValueNotifier<List<String>?> tags;
  final ValueNotifier<String> selectedCategory;

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
              LinkProvider.updateLink(
                  link: link,
                  newName: nameController.text,
                  newUrl: urlController.text,
                  newTags: tags.value,
                  completed: link.completed,
                  newCategory: selectedCategory.value);
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
