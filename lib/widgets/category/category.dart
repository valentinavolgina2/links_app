import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';

import '../forms/helper.dart';

class LinkCategory extends StatefulWidget {
  const LinkCategory(
      {super.key,
      this.categoryOptions = const [],
      required this.selectedCategory,
      this.initialCategory = ''});

  final List<String> categoryOptions;
  final ValueNotifier<String> selectedCategory;
  final String initialCategory;

  @override
  State<LinkCategory> createState() => _LinkCategoryState();
}

class _LinkCategoryState extends State<LinkCategory> {
  double optionsListMaxHeight = 200;
  double optionsListMaxWidth = AppSizes.dialogMaxWidth - 2 * AppSizes.small;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return widget.categoryOptions;
              }
              return widget.categoryOptions.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              textEditingController.text = widget.initialCategory;
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: FormHelpers.inputDecoration(hintText: 'Category'),
                onChanged: (value) {
                  widget.selectedCategory.value = value;
                },
              );
            },
            onSelected: (String selection) {
              widget.selectedCategory.value = selection;
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: AppSizes.xsmall),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: AppSizes.xsmall,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: optionsListMaxHeight,
                          maxWidth: optionsListMaxWidth),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dynamic option = options.elementAt(index);
                          return TextButton(
                            onPressed: () {
                              onSelected(option);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.medium),
                                child: Text(
                                  '$option',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
