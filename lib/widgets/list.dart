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
  List<Link> _links = [];
  late DatabaseReference _linksRef;
  late StreamSubscription<DatabaseEvent> _linksSubscription;
  late StreamSubscription<DatabaseEvent> _linksDeleteSubscription;

  final TextEditingController _linkNameController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _linksSubscription.cancel();
    _linksDeleteSubscription.cancel();
  }

  void _addLink(String listId) {
    LinkProvider.addLink(Link(
        name: _linkNameController.text,
        url: _linkUrlController.text,
        listId: listId));

    _linkNameController.clear();
    _linkUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
        color: AppColors.category.text, fontSize: AppSizes.category.text);

    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: TextField(
                    controller: _linkNameController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      hintText: 'New link name',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: TextField(
                    controller: _linkUrlController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      hintText: 'Link url',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ElevatedButton(
                    onPressed: () => _addLink(widget.list.id),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
                      child: Text('Add'),
                    )),
              ),
            ],
          ),
        ),
      ),
      subtitle: ListView(shrinkWrap: true, children: <Widget>[
        ..._links.map((link) => LinkContainer(link: link)).toList(),
      ]),
    );
  }
}
