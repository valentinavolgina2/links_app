import 'package:firebase_database/firebase_database.dart';
import 'package:string_validator/string_validator.dart';

import '../model/link.dart';

class LinkProvider {
  static const String _linksRoot = 'links';

  static DatabaseReference listLinksRef({required String? listId}) {
    return FirebaseDatabase.instance.ref('$_linksRoot/$listId');
  }

  static Future<void> addLink(
      {required String name,
      required String url,
      required String listId,
      List<String>? tags,
      String category = ''}) async {
    name = escape(name); //replace <, >, &, ' and " with HTML entities
    url = escape(url);
    category = escape(category);

    final DatabaseReference newLink = listLinksRef(listId: listId).push();

    await newLink.set({
      'name': name,
      'url': url,
      'completed': false,
      'tags': Link.strFromTagsList(tags),
      'category': category
    });
  }

  static Future<void> deleteLink(Link link) async {
    final linkRef = listLinksRef(listId: link.listId).child(link.id);
    await linkRef.remove();
  }

  static Future<void> updateLink(
      {required Link link,
      required String newName,
      required String newUrl,
      List<String>? newTags,
      required String newCategory,
      required bool completed}) async {
    newName = escape(newName); //replace <, >, &, ' and " with HTML entities
    newUrl = escape(newUrl);
    newCategory = escape(newCategory);

    final linkRef = listLinksRef(listId: link.listId).child(link.id);
    await linkRef.set({
      'name': newName,
      'url': newUrl,
      'completed': completed,
      'tags': Link.strFromTagsList(newTags),
      'category': newCategory
    });
  }

  static Future<void> complete(
      {required Link link, required bool completed}) async {
    final linkRef = listLinksRef(listId: link.listId).child(link.id);
    await linkRef.set({
      'name': link.name,
      'url': link.url,
      'completed': completed,
      'tags': Link.strFromTagsList(link.tags),
      'category': link.category,
    });
  }
}
