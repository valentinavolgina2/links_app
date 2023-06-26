import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/widgets/list/image.dart';

import '../../model/list.dart';
import '../../styles/size.dart';
import '../forms/cancel_btn.dart';
import '../forms/helper.dart';
import '../forms/update_list_image_btn.dart';

class EditListImageDialog extends StatelessWidget {
  const EditListImageDialog({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<XFile?> imgNotifier = ValueNotifier<XFile?>(null);

    return Dialog(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Update image',
                    style: TextStyle(fontSize: AppSizes.textTitle)),
                SizedBox(height: AppSizes.medium),
                ImageUpload(imgNotifier: imgNotifier, currentImageUrl: list.imgUrl),
                SizedBox(height: AppSizes.medium),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const FormCancelButton(),
                    ListImageUpdateButton(
                      list: list,
                      imgNotifier: imgNotifier
                    )
                  ]
                )
              ],
            )),
        ),
    );
  }
}
