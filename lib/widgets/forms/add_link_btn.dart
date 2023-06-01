import 'package:flutter/material.dart';
import 'package:links_app/model/list.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../providers/link.dart';
import '../../styles/size.dart';
import '../message.dart';

class LinkAddButton extends StatelessWidget {
  const LinkAddButton(
      {super.key,
      required this.list,
      required this.formKey,
      required this.nameController,
      required this.urlController,
      required this.tags,
      required this.selectedCategory});

  final LinksList list;
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
              LinkProvider.addLink(
                  name: nameController.text,
                  url: urlController.text,
                  listId: list.id,
                  tags: tags.value,
                  category: selectedCategory.value);

              Navigator.of(context).pop();

              SystemMessage.showSuccess(
                  context: context, message: 'Link was added.');

              nameController.clear();
              urlController.clear();
            }
          },
          child: const SaveButton(),
        ),
      ),
    );
  }
}
