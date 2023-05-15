import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

class FormUtils {
  static InputDecoration inputDecoration(
      {String hintText = '', String? errorText}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.inputBorder,
            width: 3,
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: AppColors.darkText,
        ),
        hintText: hintText,
        fillColor: AppColors.whiteText,
        errorText: errorText,
        errorStyle: TextStyle(
          fontSize: 12,
          color: AppColors.redText,
        ));
  }

  static BoxConstraints formMaxWidthConstraints() {
    return const BoxConstraints(maxWidth: 300);
  }

  static Widget cancelButton() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
      ),
      child: Text('Cancel'),
    );
  }

  static Widget saveButton() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
      ),
      child: Text('SAVE'),
    );
  }
}
