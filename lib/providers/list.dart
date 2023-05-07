import 'package:firebase_database/firebase_database.dart';

class ListProvider {
  static int _id = 0;
  static const String _listsRoot = 'mylists';
  static final DatabaseReference listsRef =
      FirebaseDatabase.instance.ref(_listsRoot);

  static Future<void> addList() async {
    final listName = 'List $_id';
    final DatabaseReference newList =
        FirebaseDatabase.instance.ref('$_listsRoot/$listName').push();

    await newList.parent!.set(true);

    _id++;
  }

  static Future<void> deleteList(String listKey) async {
    final listRef = listsRef.child(listKey);
    await listRef.remove();

    await FirebaseDatabase.instance.ref('links/$listKey').remove();
  }
}
