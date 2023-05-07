import 'package:firebase_database/firebase_database.dart';

import 'link.dart';

const String tableList = 'sublist';
const String columnId = 'id';
const String columnName = 'name';

class LinksList {
  final String id;
  final String name;

  List<Link> links = [];

  LinksList({required this.id, required this.name});

  LinksList.fromSnapshot(DataSnapshot snapshot):
    id = snapshot.key!,
    name = snapshot.key.toString();
  

  Map<String, String> toMap() {
    return <String, String>{
      columnId: id,
      columnName: name
    };
  }
}
