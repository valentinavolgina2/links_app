import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import '../../styles/size.dart';

class FormHelpers {
  static InputDecoration inputDecoration(
      {String hintText = '', String? errorText}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: BorderSide(
            color: AppColors.inputBorder,
            width: AppSizes.inputBorderWidth,
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: AppColors.darkText,
        ),
        hintText: '', //hintText,
        fillColor: AppColors.whiteText,
        errorText: errorText,
        errorStyle: TextStyle(
          fontSize: AppSizes.textSmall,
          color: AppColors.redText,
        ));
  }

  static BoxConstraints formMaxWidthConstraints() {
    return BoxConstraints(maxWidth: AppSizes.dialogMaxWidth);
  }
}
