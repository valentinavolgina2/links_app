import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/link.dart';
import '../model/list.dart';
import '../providers/link.dart';
import '../styles/color.dart';
import '../styles/size.dart';
import 'forms/helper.dart';
import 'link.dart';
import 'no_content.dart';

class ListContainer extends StatefulWidget {
  const ListContainer(
      {super.key,
      required this.list,
      this.withName = true,
      required this.allTags,
      required this.allCategories});

  final LinksList list;
  final bool withName;
  final ValueNotifier<List<String>> allTags;
  final ValueNotifier<List<String>> allCategories;

  @override
  State<ListContainer> createState() => _ListContainerState();
}

class CategoryExpansionPanel {
  CategoryExpansionPanel({
    required this.header,
    this.isExpanded = false,
  });

  String header;
  bool isExpanded;
}

class _ListContainerState extends State<ListContainer> {
  final List<Link> _links = [];
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;
  late StreamSubscription<DatabaseEvent> _linksDeleteSubscription;
  late StreamSubscription<DatabaseEvent> _linksUpdateSubscription;

  Set<String> tagFilters = <String>{};
  final List<CategoryExpansionPanel> categoriesWithEmpty = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _linksRef = LinkProvider.listLinksRef(listId: widget.list.id);

    _linksSubscription = _linksRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          Link newLink = Link.fromSnapshot(
              snapshot: event.snapshot, listId: widget.list.id);

          _links.add(newLink);

          _updateAllTags();
          _updateAllCategories();
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );

    _linksDeleteSubscription = _linksRef.onChildRemoved.listen(
      (DatabaseEvent event) {
        setState(() {
          final linkToRemove =
              _links.where((link) => link.id == event.snapshot.key).first;
          _links.remove(linkToRemove);

          _updateAllTags();
          _updateAllCategories();
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );

    _linksUpdateSubscription = _linksRef.onChildChanged.listen(
      (DatabaseEvent event) {
        setState(() {
          final linkToUpdate =
              _links.where((link) => link.id == event.snapshot.key).first;

          linkToUpdate.updateFromSnapshot(event.snapshot);

          _updateAllTags();
          _updateAllCategories();
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );
  }

  _updateAllTags() {
    widget.allTags.value = [];

    for (final link in _links) {
      widget.allTags.value.addAll(link.tags);
    }

    widget.allTags.value = widget.allTags.value.toSet().toList();
  }

  _updateAllCategories() {
    widget.allCategories.value = [];

    for (final link in _links) {
      widget.allCategories.value.add(link.category);
    }

    widget.allCategories.value = widget.allCategories.value.toSet().toList();
    widget.allCategories.value.sort();

    _updateAllCategoriesPanels();
  }

  _updateAllCategoriesPanels() {
    Map<String, bool> expandedValues = <String, bool>{};
    for (var categoryPanel in categoriesWithEmpty) {
      expandedValues[categoryPanel.header] = categoryPanel.isExpanded;
    }

    categoriesWithEmpty.clear();
    categoriesWithEmpty.addAll(widget.allCategories.value.map((category) =>
        CategoryExpansionPanel(
            header: category,
            isExpanded: expandedValues[category] == null
                ? false
                : expandedValues[category]!)));
  }

  @override
  void dispose() {
    super.dispose();
    _linksSubscription.cancel();
    _linksDeleteSubscription.cancel();
    _linksUpdateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        TextStyle(color: AppColors.darkText, fontSize: AppSizes.textTitle);

    return _links.isEmpty
        ? Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
                child: EmptyContainer.noLinksAdded(
                    context: context, list: widget.list)),
          )
        : SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Center(
                child: Container(
              constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0.0),
                title: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.medium, horizontal: AppSizes.small),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(widget.list.name,
                                    style: TextStyle(
                                        fontSize: titleStyle.fontSize))),
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
                                    selected: tagFilters.contains(tag),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          tagFilters.add(tag);
                                        } else {
                                          tagFilters.remove(tag);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                        ),
                        SizedBox(height: AppSizes.large),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => FormHelpers.addLink(context: context, list: widget.list, listTags: widget.allTags.value, listCategories: widget.allCategories.value), 
                            child: const Text('New link')
                          ),
                        )
                      ],
                    )),
                subtitle: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        categoriesWithEmpty[index].isExpanded = !isExpanded;
                      });
                    },
                    children: categoriesWithEmpty
                        .map<ExpansionPanel>((category) => ExpansionPanel(
                            headerBuilder: (context, isExpanded) {
                              return Padding(
                                padding: EdgeInsets.all(AppSizes.medium),
                                child: category.header == ''
                                    ? const Text('No category')
                                    : Text(category.header),
                              );
                            },
                            body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView(shrinkWrap: true, children: <Widget>[
                                    ..._links
                                        .where((link) =>
                                            link.category == category.header)
                                        .where((link) => tagFilters.isEmpty
                                            ? true
                                            : link.tags
                                                .where((tag) =>
                                                    tagFilters.contains(tag))
                                                .isNotEmpty)
                                        .map((link) => LinkContainer(
                                            link: link,
                                            listTags: widget.allTags.value,
                                            listCategories:
                                                widget.allCategories.value))
                                        .toList(),
                                  ]),
                                ]),
                            isExpanded: category.isExpanded))
                        .toList()),
              ),
            )));
  }
}
