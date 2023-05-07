

import 'package:firebase_database/firebase_database.dart';

const String tableLink = 'link';
const String columnId = 'id';
const String columnURL = 'url';
const String columnName = 'name';
const String columnList = 'list_id';

class Link {
  final String id;
  final String url;
  final String name;
  final String listId;

  Link({required this.id, required this.name, required this.url, required this.listId});

  Link.fromSnapshot(DataSnapshot snapshot, String listId):
    id = snapshot.key!,
    url = ((snapshot.value!) as Map<String, dynamic>)[columnURL]!,
    name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!,
    listId = listId;

  Map<String, Object?> toMap() {
    return <String, String>{
      columnId: id,
      columnURL: url,
      columnName: name,
      columnList: listId
    };
  }
}

