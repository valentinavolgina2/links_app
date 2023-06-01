import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../styles/size.dart';

class ListPageHeader extends StatefulWidget {
  const ListPageHeader({super.key, required this.list, required this.allTags, required this.tagFilters});

  final LinksList list;
  final ValueNotifier<List<String>> allTags;
  final ValueNotifier<Set<String>> tagFilters;

  @override
  State<ListPageHeader> createState() => _ListPageHeaderState();
}

class _ListPageHeaderState extends State<ListPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.medium, horizontal: AppSizes.small),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(widget.list.name,
                      style: TextStyle(fontSize: AppSizes.textTitle))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to lists'))
            ],
          ),
          SizedBox(height: AppSizes.large),
          const Text('Filter links by tags'),
          SizedBox(height: AppSizes.medium),
          Wrap(
            spacing: AppSizes.xsmall,
            children: widget.allTags.value.isEmpty
                ? [const Text('no tags added for this list')]
                : widget.allTags.value.map((String tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: widget.tagFilters.value.contains(tag),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            widget.tagFilters.value.add(tag);
                          } else {
                            widget.tagFilters.value.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
          ),
        ],
      ));
  }
}
