import 'package:firebase_database/firebase_database.dart';

import 'link.dart';

const String tableList = 'sublist';
const String columnId = 'id';
const String columnName = 'name';
const String columnImg = 'img';
const String columnUser = 'user';

class LinksList {
  final String id;
  String name;
  final String userId;
  String imgUrl;

  List<Link> links = [];

  LinksList(
      {this.id = '', required this.name, required this.userId, required this.imgUrl});

  LinksList.fromSnapshot({required DataSnapshot snapshot, required this.userId})
      : id = snapshot.key!,
        name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!,
        imgUrl = ((snapshot.value!) as Map<String, dynamic>)[columnImg]!;

  void updateFromSnapshot(DataSnapshot snapshot) {
    name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!;
    imgUrl = ((snapshot.value!) as Map<String, dynamic>)[columnImg]!;
  }
}
