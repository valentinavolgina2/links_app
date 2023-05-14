import 'package:firebase_database/firebase_database.dart';

const String tableLink = 'link';
const String columnId = 'id';
const String columnURL = 'url';
const String columnName = 'name';
const String columnList = 'list_id';

class Link {
  final String id;
  String url;
  String name;
  final String listId;

  Link(
      {this.id = '',
      required this.name,
      required this.url,
      required this.listId});

  Link.fromSnapshot({required DataSnapshot snapshot, required this.listId})
      : id = snapshot.key!,
        url = ((snapshot.value!) as Map<String, dynamic>)[columnURL]!,
        name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!;

  void updateFromSnapshot(DataSnapshot snapshot) {
    url = ((snapshot.value!) as Map<String, dynamic>)[columnURL]!;
    name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!;
  }
}
