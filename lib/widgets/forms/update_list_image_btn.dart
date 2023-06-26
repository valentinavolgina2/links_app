import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/model/list.dart';
import 'package:links_app/widgets/forms/save_btn.dart';

import '../../providers/list.dart';
import '../../styles/size.dart';
import '../message.dart';

class ListImageUpdateButton extends StatelessWidget {
  const ListImageUpdateButton(
      {super.key,
      required this.list,
      required this.imgNotifier});

  final LinksList list;
  final ValueNotifier<XFile?> imgNotifier;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
        child: FilledButton(
          onPressed: () {
            ListProvider.updateListImage(list: list, img: imgNotifier.value);
            Navigator.of(context).pop();

            SystemMessage.showSuccess(
                context: context, message: 'The changes were saved.');
          },
          child: const SaveButton(),
        ),
      ),
    );
  }
}
