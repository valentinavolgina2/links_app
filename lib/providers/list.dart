import 'package:firebase_database/firebase_database.dart';
import 'package:links_app/model/list.dart';
import 'package:string_validator/string_validator.dart';

import 'link.dart';

class ListProvider {
  static const String _listsRoot = 'mylists';

  static DatabaseReference userlistsRef({required String? userId}) {
    return FirebaseDatabase.instance.ref('$_listsRoot/$userId');
  }

  static Future<void> addList(
      {required String name, required String userId}) async {
    name = escape(name); //replace <, >, &, ' and " with HTML entities
    
    final DatabaseReference newList = userlistsRef(userId: userId).push();

    await newList.set(name);
  }

  static Future<void> deleteList(LinksList list) async {
    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.remove();

    await LinkProvider.listLinksRef(listId: list.id).remove();
  }

  static Future<void> updateList(
      {required LinksList list, required String newName}) async {
    newName = escape(newName); //replace <, >, &, ' and " with HTML entities

    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.set(newName);
  }
}
