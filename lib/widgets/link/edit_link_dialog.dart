import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../styles/size.dart';
import '../category/category.dart';
import '../forms/cancel_btn.dart';
import '../forms/helper.dart';
import '../forms/update_link_btn.dart';
import '../forms/validation.dart';
import '../tag/tags.dart';

class EditLinkDialog extends StatelessWidget {
  const EditLinkDialog(
      {super.key,
      required this.link,
      required this.listTags,
      required this.listCategories});

  final Link link;
  final List<String> listTags;
  final List<String> listCategories;

  @override
  Widget build(BuildContext context) {
    final TextEditingController editLinkNameController =
        TextEditingController();
    final TextEditingController editLinkUrlController = TextEditingController();
    final TextEditingController editLinkCategoryController =
        TextEditingController();

    editLinkNameController.text = link.name;
    editLinkUrlController.text = link.url;
    editLinkCategoryController.text = link.category;

    ValueNotifier<List<String>?> tags = ValueNotifier(link.tags);
    final ValueNotifier<String> selectedCategory = ValueNotifier(link.category);

    final editLinkFormKey = GlobalKey<FormState>();

    return Dialog(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.medium),
          child: Form(
              key: editLinkFormKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Editing ${link.name}',
                        style: TextStyle(fontSize: AppSizes.textTitle)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Name'),
                    SizedBox(height: AppSizes.small),
                    TextFormField(
                        controller: editLinkNameController,
                        decoration:
                            FormHelpers.inputDecoration(hintText: 'Name'),
                        maxLength: linkNameMaxLength,
                        validator: (value) => linkNameValidator(value)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Url'),
                    SizedBox(height: AppSizes.small),
                    TextFormField(
                        controller: editLinkUrlController,
                        decoration:
                            FormHelpers.inputDecoration(hintText: 'Url'),
                        validator: (value) => linkUrlValidator(value)),
                    SizedBox(height: AppSizes.medium),
                    const Text('Category'),
                    SizedBox(height: AppSizes.small),
                    LinkCategory(
                      categoryOptions: listCategories
                          .where((category) => category != '')
                          .toList(),
                      selectedCategory: selectedCategory,
                      initialCategory: link.category,
                    ),
                    SizedBox(height: AppSizes.small),
                    LinkTags(
                        initialTags: link.tags,
                        tagOptions: listTags,
                        selectedTags: tags),
                    SizedBox(height: AppSizes.medium),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const FormCancelButton(),
                          LinkUpdateButton(
                            link: link,
                            formKey: editLinkFormKey,
                            nameController: editLinkNameController,
                            urlController: editLinkUrlController,
                            tags: tags,
                            selectedCategory: selectedCategory
                          ),
                        ])
                  ])),
        ),
      ),
    );
  }
}