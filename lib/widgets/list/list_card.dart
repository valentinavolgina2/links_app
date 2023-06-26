import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';
import 'package:links_app/widgets/list/popup_menu.dart';

import '../../model/list.dart';
import '../../pages/list.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.list});
  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPage(list: list)),
                    );
                  },
            child: Container(
              decoration: BoxDecoration(
                image: list.imgUrl == '' ? null : DecorationImage(
                  opacity: 0.8,
                  fit: BoxFit.cover,  //I assumed you want to occupy the entire space of the card
                  image: NetworkImage(list.imgUrl),
                ),
              ),
              child: Center(
                child: Container(
                  width: double.infinity,
                    color:  AppColors.whiteText,
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.small),
                      child: Text(
                        list.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500)
                      ),
                    ),
                  ),
              )
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListPopupMenu(list: list)))
        ],
      ),
    );
  }
}
