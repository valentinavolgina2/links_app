import 'link.dart';

class LinksList {
  String name;
  List<Link> links;
  List<LinksList> lists;

  LinksList({required this.name, this.links = const [], this.lists = const []});
}
