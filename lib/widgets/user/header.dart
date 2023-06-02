import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/size.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.headerText});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.large),
      child: Center(
          child: Text(headerText,
              style: TextStyle(
                fontSize: AppSizes.textTitle,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2))),
    );
  }
}
