import 'package:firebase_database/firebase_database.dart';

import '../model/link.dart';

class LinkProvider {
  static const String _linksRoot = 'links';

  static Future<void> addLink(Link link) async {
    final DatabaseReference newLink =
        FirebaseDatabase.instance.ref('$_linksRoot/${link.listId}').push();

    await newLink.set({'name': link.name, 'url': link.url});
  }

  static Future<void> deleteLink(Link link) async {
    final linkRef = FirebaseDatabase.instance.ref('$_linksRoot/${link.listId}').child(link.id);
    await linkRef.remove();
  }
}
