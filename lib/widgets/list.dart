import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/link.dart';
import '../model/list.dart';
import '../providers/link.dart';
import '../styles/color.dart';
import '../styles/size.dart';
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

class _ListContainerState extends State<ListContainer> {
  final List<Link> _links = [];
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;
  late StreamSubscription<DatabaseEvent> _linksDeleteSubscription;
  late StreamSubscription<DatabaseEvent> _linksUpdateSubscription;

  Set<String> tagFilters = <String>{};
  final List<String> categoriesWithEmpty = [''];

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
          _updateAllCtegories();
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
          _updateAllCtegories();
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
          _updateAllCtegories();
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

  _updateAllCtegories() {
    widget.allCategories.value = [];

    for (final link in _links) {
      if (link.category != '') {
        widget.allCategories.value.add(link.category);
      }
    }

    widget.allCategories.value = widget.allCategories.value.toSet().toList();

    categoriesWithEmpty.clear();
    categoriesWithEmpty.add('');
    categoriesWithEmpty.addAll(widget.allCategories.value);
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
                      ],
                    )),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ...categoriesWithEmpty.map((category) => Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                category == '' ? const Text('') : Padding(
                                  padding: EdgeInsets.fromLTRB(AppSizes.medium, AppSizes.large, AppSizes.medium, AppSizes.medium),
                                  child: Text(category),
                                ),
                                ListView(shrinkWrap: true, children: <Widget>[
                                  ..._links
                                      .where(
                                          (link) => link.category == category)
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
                        ))
                  ],
                ),
              ),
            )));
  }
}
