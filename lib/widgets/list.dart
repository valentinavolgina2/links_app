import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/link.dart';
import '../model/list.dart';
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
  List<Link> _links = [];
  int _id = 0;
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _linksRef = FirebaseDatabase.instance.ref('links/${widget.list.id}');

    _linksSubscription = _linksRef.onChildAdded.listen(
      (DatabaseEvent event) {
        setState(() {
          _links.add(Link.fromSnapshot(event.snapshot, widget.list.id));
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _linksSubscription.cancel();
  }

  Future<void> _addLink() async {
    final linkName = 'Name $_id';
    final linkUrl = 'Url $_id';
    final DatabaseReference newLink =
        FirebaseDatabase.instance.ref('links/${widget.list.id}').push();
    await newLink.set({'name': linkName, 'url': linkUrl});

    _id++;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
        color: AppColors.category.text, fontSize: AppSizes.category.text);

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
          title: (widget.withName)
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(widget.list.name, style: titleStyle),
                )
              : const SizedBox.shrink(),
          subtitle: ListView(shrinkWrap: true, children: <Widget>[
            ..._links.map((link) => LinkContainer(link: link)).toList(),
          ]),
        ),
        FloatingActionButton(
          onPressed: _addLink,
          tooltip: 'Add new link',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
