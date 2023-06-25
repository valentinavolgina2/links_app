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
        height: 300,
        decoration: BoxDecoration(
          image: list.imgUrl == '' ? null : DecorationImage(
            opacity: 0.5,
            fit: BoxFit.fitWidth,  //I assumed you want to occupy the entire space of the card
            image: NetworkImage(list.imgUrl),
          ),
        ),
        child: ListTile(
            title: Center(child: Container(padding: EdgeInsets.all(AppSizes.small), color: AppColors.whiteText, child: Text(list.name))),
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

class ListImage extends StatelessWidget {
  const ListImage({super.key, required this.list});
  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          minWidth: double.infinity, minHeight: 100, maxHeight: 300),
      decoration: BoxDecoration(color: AppColors.lightGrey),
      child: list.imgUrl == ''
          ? Icon(
              Icons.camera_alt,
              color: AppColors.darkText,
            )
          : Image.network(
              list.imgUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )
      );
  }
}
