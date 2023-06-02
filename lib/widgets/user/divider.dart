import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import '../../styles/size.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.small),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: AppSizes.googleBorderWidth,
              color: AppColors.secondaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.medium),
            child: Text(
              'or',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: AppSizes.googleBorderWidth,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}