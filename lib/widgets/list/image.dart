import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/styles/color.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key, required this.imgNotifier});

  final ValueNotifier<XFile?> imgNotifier;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  Uint8List? _imgBytes;

  Future imgFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.imgNotifier.value = image;

      _imgBytes = await image.readAsBytes();

      setState(() {});
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        imgFromGallery();
      },
      child: Container(
          constraints: const BoxConstraints(
              minWidth: double.infinity, minHeight: 100, maxHeight: 300),
          decoration: BoxDecoration(color: AppColors.lightGrey),
          child: _imgBytes == null
              ? Icon(
                  Icons.camera_alt,
                  color: AppColors.darkText,
                )
              : Image.memory(
                  _imgBytes!,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )
          // Image.network(
          //           //   _imgUrl!,
          //           //   width: 100,
          //           //   height: 100,
          //           //   fit: BoxFit.fitHeight,
          //           // ),
          //           )
          ),
    ));
  }
}