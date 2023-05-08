import 'package:firebase_database/firebase_database.dart';

class ListProvider {
  static const String _listsRoot = 'mylists';
  static final DatabaseReference listsRef =
      FirebaseDatabase.instance.ref(_listsRoot);

  static Future<void> addList(String listName) async {
    final DatabaseReference newList =
        FirebaseDatabase.instance.ref('$_listsRoot/$listName').push();

    await newList.parent!.set(true);
  }

  static Future<void> deleteList(String listKey) async {
    final listRef = listsRef.child(listKey);
    await listRef.remove();

    await FirebaseDatabase.instance.ref('links/$listKey').remove();
  }
}
