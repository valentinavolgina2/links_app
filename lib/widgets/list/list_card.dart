import 'package:flutter/material.dart';
import 'package:links_app/styles/size.dart';
import 'package:links_app/widgets/list/popup_menu.dart';

import '../../model/list.dart';
import '../../pages/list.dart';
import '../../styles/color.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.list});
  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        //constraints: BoxConstraints(minHeight: 100, maxHeight: 400),
        //height: 300,
        decoration: BoxDecoration(
          image: list.imgUrl == '' ? null : DecorationImage(
            opacity: 0.4,
            fit: BoxFit.cover,  //I assumed you want to occupy the entire space of the card
            image: NetworkImage(list.imgUrl),
          ),
        ),
        child: ListTile(
            title: Text(list.name),
            trailing: ListPopupMenu(list: list),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPage(list: list)),
              );
            }),
      ),
    );
  }
}
