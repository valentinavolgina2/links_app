import 'package:firebase_database/firebase_database.dart';

const String tableLink = 'link';
const String columnId = 'id';
const String columnURL = 'url';
const String columnName = 'name';
const String columnCompleted = 'completed';
const String columnTags = 'tags';
const String columnCategory = 'category';
const String columnList = 'list_id';

class Link {
  final String id;
  String url;
  String name;
  bool completed;
  List<String> tags;
  String category;
  final String listId;

  Link(
      {this.id = '',
      required this.name,
      required this.url,
      this.completed = false,
      this.tags = const [],
      this.category = '',
      required this.listId});

  Link.fromSnapshot({required DataSnapshot snapshot, required this.listId})
      : id = snapshot.key!,
        url = ((snapshot.value!) as Map<String, dynamic>)[columnURL]!,
        name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!,
        tags = tagsFromString(
            ((snapshot.value!) as Map<String, dynamic>)[columnTags]!),
        category = ((snapshot.value!) as Map<String, dynamic>)[columnCategory] == null ? '' : ((snapshot.value!) as Map<String, dynamic>)[columnCategory]!,
        completed =
            ((snapshot.value!) as Map<String, dynamic>)[columnCompleted]!;

  void updateFromSnapshot(DataSnapshot snapshot) {
    url = ((snapshot.value!) as Map<String, dynamic>)[columnURL]!;
    name = ((snapshot.value!) as Map<String, dynamic>)[columnName]!;
    tags = tagsFromString(
        ((snapshot.value!) as Map<String, dynamic>)[columnTags]!);
    category = ((snapshot.value!) as Map<String, dynamic>)[columnCategory] == null ? '' : ((snapshot.value!) as Map<String, dynamic>)[columnCategory]!;
    completed = ((snapshot.value!) as Map<String, dynamic>)[columnCompleted]!;
  }

  static List<String> tagsFromString(String? str) {
    if (str == null || str.isEmpty) {
      return [];
    } else {
      return str.split(',');
    }
  }

  static String strFromTagsList(List<String>? tags) {
    if (tags == null || tags.isEmpty) {
      return '';
    } else {
      return tags.join(',');
    }
  }

  static String hashStrFromTagsList(List<String>? tags) {
    if (tags == null || tags.isEmpty) {
      return '';
    } else {
      return tags.map((e) => '#$e').join(' ');
    }
  }
}
