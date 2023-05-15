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

class ListContainer extends StatefulWidget {
  const ListContainer({super.key, required this.list, this.withName = true});

  final LinksList list;
  final bool withName;

  @override
  State<ListContainer> createState() => _ListContainerState();
}

class _ListContainerState extends State<ListContainer> {
  final List<Link> _links = [];
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;
  late StreamSubscription<DatabaseEvent> _linksDeleteSubscription;
  late StreamSubscription<DatabaseEvent> _linksUpdateSubscription;

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
          _links.add(Link.fromSnapshot(
              snapshot: event.snapshot, listId: widget.list.id));
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
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        debugPrint('Error: ${error.code} ${error.message}');
      },
    );
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
    final TextStyle titleStyle = TextStyle(
        color: AppColors.darkText, fontSize: AppSizes.textTitle);

    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.medium, horizontal: AppSizes.small),
          child: Text(widget.list.name,
              style: TextStyle(fontSize: titleStyle.fontSize))),
      subtitle: ListView(shrinkWrap: true, children: <Widget>[
        ..._links.map((link) => LinkContainer(link: link)).toList(),
      ]),
    );
  }
}
