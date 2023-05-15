import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

class SystemMessage {
  static void showSuccess(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showError(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.redBackground,
      ),
    );
  }
}
