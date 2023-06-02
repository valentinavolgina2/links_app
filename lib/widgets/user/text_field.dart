import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key, required this.label, required this.fieldType, required this.controller});

  final String label;
  final TextInputType fieldType;
  final TextEditingController controller;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(label)),
        SizedBox(height: AppSizes.small),
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          style: TextStyle(color: AppColors.darkText),
          decoration: FormHelpers.inputDecoration(
            hintText: label,
          ),
        )
      ]
    );
  }
}
