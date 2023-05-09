import 'package:firebase_database/firebase_database.dart';

import 'link.dart';

const String tableList = 'sublist';
const String columnId = 'id';
const String columnName = 'name';

class LinksList {
  final String id;
  String name;

  List<Link> links = [];

  LinksList({this.id = '', required this.name});

  LinksList.fromSnapshot(DataSnapshot snapshot):
    id = snapshot.key!,
    name = snapshot.value.toString();
  

  Map<String, String> toMap() {
    return <String, String>{
      columnId: id,
      columnName: name
    };
  }
}
