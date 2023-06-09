import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../forms/helper.dart';

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
  double optionsListMaxWidth = AppSizes.dialogMaxWidth - 2 * AppSizes.medium;

  final TextfieldTagsController _controller = TextfieldTagsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller.addListener(_updateSelectedTags);
    super.initState();
  }

  _updateSelectedTags() {
    setState(() {
      widget.selectedTags.value = _controller.getTags;
    });
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
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: AppSizes.xsmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text('Tags')),
          SizedBox(height: AppSizes.small),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: AppSizes.xsmall,
              runSpacing: AppSizes.xsmall,
              children: widget.selectedTags.value == null
                  ? [const SizedBox()]
                  : widget.selectedTags.value!.map((String tag) {
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tag),
                            SizedBox(width: AppSizes.xsmall),
                            Icon(Icons.cancel,
                                size: AppSizes.deleteIcon),
                          ],
                        ),
                        tooltip: 'Delete $tag',
                        selected: false,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected && widget.selectedTags.value != null) {
                              widget.selectedTags.value!.remove(tag);
                              widget.selectedTags.value =
                                  List<String>.from(widget.selectedTags.value!);

                              _controller.onTagDelete(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
            ),
          ),
          Autocomplete<String>(
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: AppSizes.xsmall,
                  color: AppColors.lightGrey,
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
                        decoration: FormHelpers.inputDecoration(
                            hintText: 'Tags',
                            errorText: error,
                            helperText: 'Enter tag...'),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    );
                  });
                },
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }
}
