import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../model/list.dart';
import '../../providers/link.dart';
import '../../styles/size.dart';
import '../emty_content/no_links.dart';
import '../link/link_category_panel.dart';
import 'header.dart';

class CategoryExpansionPanel {
  CategoryExpansionPanel({
    required this.header,
    this.isExpanded = false,
  });

  String header;
  bool isExpanded;
}

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

class _ListContainerState extends State<ListContainer> {
  final List<Link> _links = [];
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;
  late StreamSubscription<DatabaseEvent> _linksDeleteSubscription;
  late StreamSubscription<DatabaseEvent> _linksUpdateSubscription;

  ValueNotifier<Set<String>> tagFilters = ValueNotifier(<String>{});
  final List<CategoryExpansionPanel> categoriesWithEmpty = [];
  int _count = 0;
  late Key _panelKey;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    
    init();
  }

  Future<void> init() async {
    _panelKey = Key('$_count');

    _linksRef = LinkProvider.listLinksRef(listId: widget.list.id);

    _linksSubscription = _linksRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          Link newLink = Link.fromSnapshot(
              snapshot: event.snapshot, listId: widget.list.id);

          _links.add(newLink);

          _updateAllTags();
          _updateAllCategories();
          _updatePanelKey();
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
          _updatePanelKey();
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
          _updatePanelKey();
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );

    tagFilters.addListener(() {
      setState(() {});
    });

    final snapshot = await _linksRef.get();
    if (snapshot.exists) {
      //print(snapshot.value);
    } else {
      //print('No data available.');
    }

    setState(() {
      loading = false;
    });
  }

  _updatePanelKey() {
    _panelKey = Key("${++_count}");
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
                ? true
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
    return loading
        ? const SizedBox()
        : _links.isEmpty
            ? Center(
                child: Container(
                    constraints:
                        BoxConstraints(maxWidth: AppSizes.listMaxWidth),
                    child: NoLinksPage(list: widget.list)),
              )
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Center(
                    child: Container(
                  constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: ListPageHeader(
                        list: widget.list,
                        allTags: widget.allTags,
                        tagFilters: tagFilters),
                    subtitle: ExpansionPanelList(
                        key: _panelKey,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            categoriesWithEmpty[index].isExpanded = !isExpanded;
                          });
                        },
                        children: categoriesWithEmpty
                            .map<ExpansionPanel>((category) =>
                                categoryExpansionPanel(
                                    category: category,
                                    links: _links,
                                    tagFilters: tagFilters.value,
                                    allTags: widget.allTags.value,
                                    allCategories: widget.allCategories.value))
                            .toList()),
                  ),
                )));
  }
}
