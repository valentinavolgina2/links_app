import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/forms/validation.dart';

import '../../model/list.dart';
import '../../providers/link.dart';
import '../../providers/list.dart';
import '../../styles/size.dart';
import '../category.dart';
import '../message.dart';
import '../tags.dart';

class FormHelpers {
  static InputDecoration inputDecoration(
      {String hintText = '', String? errorText}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: BorderSide(
            color: AppColors.inputBorder,
            width: AppSizes.inputBorderWidth,
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: AppColors.darkText,
        ),
        hintText: '', //hintText,
        fillColor: AppColors.whiteText,
        errorText: errorText,
        errorStyle: TextStyle(
          fontSize: AppSizes.textSmall,
          color: AppColors.redText,
        ));
  }

  static BoxConstraints formMaxWidthConstraints() {
    return BoxConstraints(maxWidth: AppSizes.dialogMaxWidth);
  }

  static Widget cancelButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSizes.medium,
        bottom: AppSizes.medium,
      ),
      child: const Text('Cancel'),
    );
  }

  static Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSizes.medium,
        bottom: AppSizes.medium,
      ),
      child: const Text('SAVE'),
    );
  }

  static titleTextStyle() {}

  static addLink(
      {required BuildContext context,
      required LinksList list,
      List<String> listTags = const [],
      List<String> listCategories = const []}) {
    final TextEditingController linkNameController = TextEditingController();
    final TextEditingController linkUrlController = TextEditingController();

    ValueNotifier<List<String>?> tags = ValueNotifier([]);
    final ValueNotifier<String> selectedCategory = ValueNotifier('');

    final addLinkFormKey = GlobalKey<FormState>();

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
                  key: addLinkFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Adding new link',
                            style: TextStyle(fontSize: AppSizes.textTitle)),
                        SizedBox(height: AppSizes.medium),
                        const Text('Name'),
                        SizedBox(height: AppSizes.small),
                        TextFormField(
                          controller: linkNameController,
                          decoration:
                              FormHelpers.inputDecoration(hintText: 'Name'),
                          maxLength: linkNameMaxLength,
                          validator: (value) => linkNameValidator(value),
                        ),
                        SizedBox(height: AppSizes.medium),
                        const Text('Url'),
                        SizedBox(height: AppSizes.small),
                        TextFormField(
                          controller: linkUrlController,
                          decoration:
                              FormHelpers.inputDecoration(hintText: 'Url'),
                          validator: (value) => linkUrlValidator(value),
                        ),
                        SizedBox(height: AppSizes.medium),
                        const Text('Category'),
                        SizedBox(height: AppSizes.small),
                        LinkCategory(
                          categoryOptions: listCategories,
                          selectedCategory: selectedCategory,
                        ),
                        SizedBox(height: AppSizes.small),
                        LinkTags(
                            tagOptions: listTags,
                            selectedTags: tags),
                        SizedBox(height: AppSizes.medium),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.only(
                                      left: AppSizes.small,
                                      right: AppSizes.small),
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                        backgroundColor:
                                            AppColors.secondaryColor),
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
                                  padding: EdgeInsets.only(
                                      left: AppSizes.small,
                                      right: AppSizes.small),
                                  child: FilledButton(
                                    onPressed: () {
                                      if (addLinkFormKey.currentState!
                                          .validate()) {
                                        LinkProvider.addLink(
                                            name: linkNameController.text,
                                            url: linkUrlController.text,
                                            listId: list.id,
                                            tags: tags.value,
                                            category:
                                                selectedCategory.value);

                                        Navigator.of(context).pop();

                                        SystemMessage.showSuccess(
                                            context: context,
                                            message: 'Link was added.');

                                        linkNameController.clear();
                                        linkUrlController.clear();
                                      }
                                    },
                                    child: FormHelpers.saveButton(),
                                  ),
                                ),
                              ),
                            ])
                      ])),
            ),
          ),
        );
      },
    );
  }

  static addList({required BuildContext context, required String userId}) {
    final TextEditingController addListController = TextEditingController();
    final addListFormKey = GlobalKey<FormState>();

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
                  key: addListFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Adding new list',
                          style: TextStyle(fontSize: AppSizes.textTitle)),
                      SizedBox(height: AppSizes.medium),
                      const Text('Name'),
                      SizedBox(height: AppSizes.small),
                      TextFormField(
                        controller: addListController,
                        decoration:
                            FormHelpers.inputDecoration(hintText: 'Name'),
                        maxLength: listNameMaxLength,
                        validator: (value) => listNameValidator(value),
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
                                padding: EdgeInsets.only(
                                    left: AppSizes.small,
                                    right: AppSizes.small),
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                      backgroundColor:
                                          AppColors.secondaryColor),
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
                                padding: EdgeInsets.only(
                                    left: AppSizes.small,
                                    right: AppSizes.small),
                                child: FilledButton(
                                  onPressed: () {
                                    if (addListFormKey.currentState!
                                        .validate()) {
                                      ListProvider.addList(
                                          name: addListController.text,
                                          userId: userId);

                                      Navigator.of(context).pop();

                                      SystemMessage.showSuccess(
                                          context: context,
                                          message:
                                              'List ${addListController.text} was added.');

                                      addListController.clear();
                                    }
                                  },
                                  child: FormHelpers.saveButton(),
                                ),
                              ),
                            ),
                          ])
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
