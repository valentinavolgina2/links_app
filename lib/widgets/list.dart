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
      required this.allTags});

  final LinksList list;
  final bool withName;
  final ValueNotifier<List<String>> allTags;

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
                        SizedBox(height: AppSizes.medium),
                      ],
                    )),
                subtitle: ListView(
                    shrinkWrap: true,
                    children: tagFilters.isEmpty
                        ? <Widget>[
                            ..._links
                                .map((link) => LinkContainer(link: link, listTags: widget.allTags.value))
                                .toList(),
                          ]
                        : <Widget>[
                            ..._links
                                .where((link) => link.tags
                                    .where((tag) => tagFilters.contains(tag))
                                    .isNotEmpty)
                                .map((link) => LinkContainer(link: link, listTags: widget.allTags.value))
                                .toList(),
                          ]),
              ),
            )));
  }
}
