import 'package:firebase_database/firebase_database.dart';

class LinkProvider {
  static int _id = 0;
  static const String _linksRoot = 'links';

  static Future<void> addLink({required String listId}) async {
    final linkName = 'Name $_id';
    final linkUrl = 'Url $_id';

    final DatabaseReference newLink =
        FirebaseDatabase.instance.ref('$_linksRoot/$listId').push();

    await newLink.set({'name': linkName, 'url': linkUrl});

    _id++;
  }

  static Future<void> deleteLink({required String linkKey, required String listId}) async {
    final linkRef = FirebaseDatabase.instance.ref('$_linksRoot/$listId').child(linkKey);
    await linkRef.remove();
  }
}
