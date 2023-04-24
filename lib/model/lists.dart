import 'link.dart';
import 'linkslist.dart';

// https://www.mysqltutorial.org/mysql-adjacency-list-tree/
final myLists = [
  LinksList(name: 'Amazon', links: [
    Link(name:'Product 1',
        url: 'https://www.amazon.com/gp/product/B01LWC7XTW/ref=ox_sc_act_title_3?smid=A1M24Z1DO0DHDE&th=1&psc=1'),
    Link(name: 'Another product',
        url: 'https://www.amazon.com/gp/product/B083CTQ518/ref=ewc_pr_img_1?smid=A22EDVDQDLC8XN&psc=1'),
    Link(name: 'Last product',
        url: 'https://www.amazon.com/gp/product/B01LR5SM74/ref=ewc_pr_img_2?smid=ATVPDKIKX0DER&psc=1'),
  ]),
  LinksList(name: 'Nursery', links: [
    Link(name: 'IKEA drawer',
        url: 'https://www.ikea.com/us/en/p/bjoerksnaes-5-drawer-chest-birch-70407303/#content'),
    Link(name: 'IKEA crib',
      url: 'https://www.ikea.com/us/en/p/sundvik-crib-gray-50494080/#content'),
    Link(name: 'IKEA curtains',
        url: 'https://www.ikea.com/us/en/p/naeckrosmott-curtains-1-pair-beige-black-60529507/'),
  ]),
];

List<String> myListsNames() {
  return myLists.map((list) => list.name).toList();
}
