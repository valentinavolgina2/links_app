import 'dart:html' as html;
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/model/list.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:string_validator/string_validator.dart';

import 'link.dart';

class ListProvider {
  static const String _listsRoot = 'mylists';

  static DatabaseReference userlistsRef({required String? userId}) {
    return FirebaseDatabase.instance.ref('$_listsRoot/$userId');
  }

  static Future<void> addList(
      {required String name, required String userId, XFile? img}) async {
    name = escape(name); //replace <, >, &, ' and " with HTML entities

    try {
      final DatabaseReference newList = userlistsRef(userId: userId).push();
      await newList.set({'name': name, 'img': ''});

      if (img != null && newList.key != null) {
        await _updateListImage(userId: userId, listId: newList.key!, file: img);
      }
    } catch (err) {
      debugPrint(err.toString());
      return;
    }
  }

  static Future<void> deleteList(LinksList list) async {
    await _deleteListImage(listId: list.id, userId: list.userId);

    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.remove();

    await LinkProvider.listLinksRef(listId: list.id).remove();
  }

  static Future<void> updateList(
      {required LinksList list, required String newName}) async {
    newName = escape(newName); //replace <, >, &, ' and " with HTML entities

    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.update({'name': newName});
  }

  static Future<void> updateListImage(
      {required LinksList list, XFile? img}) async {
    if (img == null && list.imgUrl == '') {
      return;
    }

    try {
      if (img == null) {
        await _deleteListImage(listId: list.id, userId: list.userId);
      } else {
        await _updateListImage(userId: list.userId, listId: list.id, file: img);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  static Future<void> _updateListImage(
      {required String userId,
      required String listId,
      required XFile file}) async {
    final url = file.path;
    SettableMetadata meta =
        SettableMetadata(contentType: mime(basename(file.name)));

    var xhr = html.HttpRequest();
    xhr.open("GET", url);
    xhr.setRequestHeader('Access-Control-Allow-Origin', 'https://links-app-d361f.web.app');
    xhr.responseType = "blob";
    xhr.addEventListener('load', (e) async {
      final blob = xhr.response;

      final res = await FirebaseStorage.instance
          .ref()
          .child('images/$listId')
          .putBlob(blob, meta);

      final fileUrl = await res.ref.getDownloadURL();

      final listRef = userlistsRef(userId: userId).child(listId);
      await listRef.update({'img': fileUrl});
    });
    xhr.send();
  }

  static Future<void> _deleteListImage(
      {required String listId, required String userId}) async {
    await FirebaseStorage.instance.ref().child('images/$listId').delete();

    final listRef = userlistsRef(userId: userId).child(listId);
    await listRef.update({'img': ''});
  }
}
