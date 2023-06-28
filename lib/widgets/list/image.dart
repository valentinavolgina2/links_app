import 'dart:core';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload({super.key, required this.imgNotifier, this.currentImageUrl});

  final ValueNotifier<XFile?> imgNotifier;
  String? currentImageUrl;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  Uint8List? _imgBytes;


  Future imgFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.currentImageUrl = '';

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
    print(widget.imgNotifier);

    return Stack(
      children: [
        Center(
            child: GestureDetector(
                onTap: () {
                  imgFromGallery();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 100,
                          maxHeight: 300),
                      decoration: BoxDecoration(color: AppColors.lightGrey),
                      child: widget.currentImageUrl != null && widget.currentImageUrl != ''
                          ? Image.network(
                              widget.currentImageUrl!,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            )
                          : _imgBytes == null
                              ? Icon(
                                  Icons.camera_alt,
                                  color: AppColors.darkText,
                                )
                              : Image.memory(
                                  _imgBytes!,
                                  width: double.infinity,
                                  fit: BoxFit.fitWidth,
                                )),
                ))),
        widget.currentImageUrl != '' || _imgBytes != null
            ? Positioned(
                top: 5,
                right: 5,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.currentImageUrl = '';
                        widget.imgNotifier.value = null;
                        _imgBytes = null;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppSizes.googleButtonRadius)),
                          color: AppColors.whiteText,
                        ),
                        child: const Icon(Icons.close)),
                  ),
                ))
            : const SizedBox(),
      ],
    );
  }
}
