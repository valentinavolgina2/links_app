import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';
import 'package:textfield_tags/textfield_tags.dart';

class LinkTags extends StatefulWidget {
  const LinkTags(
      {super.key,
      required this.selectedTags,
      this.initialTags = const [],
      this.tagOptions = const []});

  final List<String> initialTags;
  final List<String> tagOptions;
  final ValueNotifier<List<String>?> selectedTags;

  @override
  State<LinkTags> createState() => _LinkTagsState();
}

class _LinkTagsState extends State<LinkTags> {
  List<String> tagSeparators = [' ', ','];

  double optionsListMaxHeight = 200;
  double optionsListMaxWidth = AppSizes.dialogMaxWidth - 2 * AppSizes.small;

  late double _distanceToField = 0;
  final TextfieldTagsController _controller = TextfieldTagsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    _controller.addListener(_updateSelectedTags);
    super.initState();
  }

  _updateSelectedTags() {
    widget.selectedTags.value = _controller.getTags;
  }

  _tagValidator(String tag) {
    if (tag == ' ') {
      return 'No, please no empty tags';
    } else if (_controller.getTags != null &&
        _controller.getTags!.contains(tag)) {
      return 'you already entered that';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppSizes.xsmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<String>(
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
                                  '#$option',
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
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return widget.tagOptions;
              }
              return widget.tagOptions.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selectedTag) {
              _controller.addTag = selectedTag;
            },
            fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
              return TextFieldTags(
                textEditingController: ttec,
                focusNode: tfn,
                textfieldTagsController: _controller,
                initialTags: widget.initialTags,
                textSeparators: tagSeparators,
                letterCase: LetterCase.normal,
                validator: (tag) => _tagValidator(tag),
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.small),
                      child: TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.secondaryColor,
                                width: AppSizes.inputBorderWidth),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.secondaryColor,
                                width: AppSizes.inputBorderWidth),
                          ),
                          helperText: 'Enter tag...',
                          helperStyle: TextStyle(
                            color: AppColors.darkText,
                          ),
                          hintText: _controller.hasTags ? '' : "Enter tag...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppSizes.inputBorderRadius),
                                        ),
                                        color: AppColors.secondaryColor,
                                      ),
                                      margin: EdgeInsets.only(
                                          right: AppSizes.small),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppSizes.small,
                                          vertical: AppSizes.xsmall),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text('#$tag',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.whiteText)),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          SizedBox(width: AppSizes.xsmall),
                                          InkWell(
                                            child: Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: AppColors.secondaryFade,
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    );
                  });
                },
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.secondaryColor,
              ),
            ),
            onPressed: () {
              _controller.clearTags();
            },
            child: const Text('Clear tags'),
          ),
        ],
      ),
    );
  }
}
