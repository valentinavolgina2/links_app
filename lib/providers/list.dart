import 'package:firebase_database/firebase_database.dart';
import 'package:links_app/model/list.dart';

class ListProvider {
  static const String _listsRoot = 'mylists';
  static final DatabaseReference listsRef =
      FirebaseDatabase.instance.ref(_listsRoot);

  static Future<void> addList(String listName, String userId) async {
    final DatabaseReference newList =
        FirebaseDatabase.instance.ref('$_listsRoot/$userId').push();

    await newList.set(listName);
  }

  static Future<void> deleteList(LinksList list) async {
    final listRef = FirebaseDatabase.instance.ref('$_listsRoot/${list.userId}').child(list.id);
    await listRef.remove();

    await FirebaseDatabase.instance.ref('links/${list.id}').remove();
  }

  static Future<void> updateList({required LinksList list, required String newName}) async {
    final listRef = FirebaseDatabase.instance.ref('$_listsRoot/${list.userId}').child(list.id);
    await listRef.set(newName);
  }
}
