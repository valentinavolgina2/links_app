import 'dart:html' as html;
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
      if (img != null) {
        await _addListWithImage(name: name, userId: userId, file: img);
      } else {
        final DatabaseReference newList = userlistsRef(userId: userId).push();

        await newList.set({'name': name, 'img': ''});
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  static Future<void> deleteList(LinksList list) async {
    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.remove();

    await LinkProvider.listLinksRef(listId: list.id).remove();

    // TODO: remove img
  }

  static Future<void> updateList(
      {required LinksList list, required String newName}) async {
    newName = escape(newName); //replace <, >, &, ' and " with HTML entities

    final listRef = userlistsRef(userId: list.userId).child(list.id);
    await listRef.set({'name': newName, 'img': list.imgUrl});
  }

  static Future<void> _addListWithImage(
      {required String name,
      required String userId,
      required XFile file}) async {
    try {
      final url = file.path;
      SettableMetadata meta =
          SettableMetadata(contentType: mime(basename(file.name)));

      var xhr = html.HttpRequest();
      xhr.open("GET", url);
      xhr.responseType = "blob";
      xhr.addEventListener('load', (e) async {
        final blob = xhr.response;

        final res = await FirebaseStorage.instance
            .ref()
            .child('images/${file.name}')
            .putBlob(blob, meta);

        final fileUrl = await res.ref.getDownloadURL();

        final DatabaseReference newList = userlistsRef(userId: userId).push();
        await newList.set({'name': name, 'img': fileUrl});
      });
      xhr.send();

      /// Use fileURL to save in Firebase document or show the uploaded file
    } catch (err) {
      debugPrint(err.toString());
      throw Exception(['Error occured during file uploading.']);
    }
  }
}
