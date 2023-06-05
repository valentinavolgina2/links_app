import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import '../../model/list.dart';
import '../../styles/size.dart';
import '../category/category.dart';
import '../forms/add_link_btn.dart';
import '../forms/cancel_btn.dart';
import '../forms/helper.dart';
import '../forms/validation.dart';
import '../tag/tags.dart';
import 'label.dart';

class LinkAddDialog extends StatelessWidget {
  const LinkAddDialog(
      {super.key,
      required this.list,
      this.listTags = const [],
      this.listCategories = const [],
      this.category = ''});

  final LinksList list;
  final List<String> listTags;
  final List<String> listCategories;
  final String category;

  @override
  Widget build(BuildContext context) {
    final TextEditingController linkNameController = TextEditingController();
    final TextEditingController linkUrlController = TextEditingController();

    final ValueNotifier<List<String>?> tags = ValueNotifier([]);
    final ValueNotifier<String> selectedCategory = ValueNotifier(category);

    final addLinkFormKey = GlobalKey<FormState>();

    return Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: AppSizes.dialogMaxWidth),
          child: Form(
                  key: addLinkFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: AppSizes.dialogHeight,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.medium),
                              child: Column(
                                children: [
                                  Text('Adding new link',
                                    style: TextStyle(fontSize: AppSizes.textTitle)),
                                  SizedBox(height: AppSizes.medium),
                                  const LinkFormLabel(text: 'Name'),
                                  SizedBox(height: AppSizes.small),
                                  TextFormField(
                                    controller: linkNameController,
                                    decoration: FormHelpers.inputDecoration(hintText: 'Name'),
                                    maxLength: linkNameMaxLength,
                                    validator: (value) => linkNameValidator(value),
                                  ),
                                  SizedBox(height: AppSizes.medium),
                                  const LinkFormLabel(text: 'Url'),
                                  SizedBox(height: AppSizes.small),
                                  TextFormField(
                                    controller: linkUrlController,
                                    decoration: FormHelpers.inputDecoration(hintText: 'Url'),
                                    validator: (value) => linkUrlValidator(value),
                                  ),
                                  SizedBox(height: AppSizes.medium),
                                  const LinkFormLabel(text: 'Category'),
                                  SizedBox(height: AppSizes.small),
                                  LinkCategory(
                                    categoryOptions: listCategories
                                        .where((category) => category != '')
                                        .toList(),
                                    selectedCategory: selectedCategory,
                                    initialCategory: category,
                                  ),
                                  SizedBox(height: AppSizes.medium),
                                  LinkTags(tagOptions: listTags, selectedTags: tags),
                                  SizedBox(height: AppSizes.medium),
                                ]
                              ),
                            ),
                          )
                        ),
                        Container(
                          color: AppColors.lightGrey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: AppSizes.medium, horizontal: AppSizes.small),
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const FormCancelButton(),
                                  LinkAddButton(
                                    list: list,
                                    formKey: addLinkFormKey,
                                    nameController: linkNameController,
                                    urlController: linkUrlController,
                                    tags: tags,
                                    selectedCategory: selectedCategory
                                  )
                                ]),
                          ),
                        )
                      ])),
            ),
    );
  }
}
