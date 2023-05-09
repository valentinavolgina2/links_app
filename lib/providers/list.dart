import 'package:firebase_database/firebase_database.dart';
import 'package:links_app/model/list.dart';

class ListProvider {
  static const String _listsRoot = 'mylists';
  static final DatabaseReference listsRef =
      FirebaseDatabase.instance.ref(_listsRoot);

  static Future<void> addList(String listName) async {
    final DatabaseReference newList = listsRef.push();

    await newList.set(listName);
  }

  static Future<void> deleteList(String listKey) async {
    final listRef = listsRef.child(listKey);
    await listRef.remove();

    await FirebaseDatabase.instance.ref('links/$listKey').remove();
  }

  static Future<void> updateList({required LinksList list, required String newName}) async {
    final listRef = listsRef.child(list.id);
    await listRef.set(newName);
  }
}
