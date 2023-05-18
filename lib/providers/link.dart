import 'package:firebase_database/firebase_database.dart';
import 'package:string_validator/string_validator.dart';

import '../model/link.dart';

class LinkProvider {
  static const String _linksRoot = 'links';

  static DatabaseReference listLinksRef({required String? listId}) {
    return FirebaseDatabase.instance.ref('$_linksRoot/$listId');
  }

  static Future<void> addLink({required String name, required String url, required String listId}) async {
    name = escape(name); //replace <, >, &, ' and " with HTML entities
    url = escape(url);
    
    final DatabaseReference newLink = listLinksRef(listId: listId).push();

    await newLink.set({'name': name, 'url': url});
  }

  static Future<void> deleteLink(Link link) async {
    final linkRef = listLinksRef(listId: link.listId).child(link.id);
    await linkRef.remove();
  }

  static Future<void> updateLink({required Link link, required String newName, required String newUrl}) async {
    newName = escape(newName); //replace <, >, &, ' and " with HTML entities
    newUrl = escape(newUrl);

    final linkRef = listLinksRef(listId: link.listId).child(link.id);
    await linkRef.set({'name': newName, 'url': newUrl});
  }
}
