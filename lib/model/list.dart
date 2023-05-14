import 'package:firebase_database/firebase_database.dart';

import 'link.dart';

const String tableList = 'sublist';
const String columnId = 'id';
const String columnName = 'name';
const String columnUser = 'user';

class LinksList {
  final String id;
  String name;
  final String userId;

  List<Link> links = [];

  LinksList({this.id = '', required this.name, required this.userId});

  LinksList.fromSnapshot(DataSnapshot snapshot, this.userId)
      : id = snapshot.key!,
        name = snapshot.value.toString();
}
