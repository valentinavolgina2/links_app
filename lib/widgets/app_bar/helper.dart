import 'package:flutter/material.dart';

import '../../model/app.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';

AppBar smallScreenAppBar() {
  return AppBar(
    // for smaller screen sizes
    backgroundColor: AppColors.primaryColor,
    elevation: 0,
    title: Text(
      AppData.title.toUpperCase(),
      style: TextStyle(
        color: AppColors.secondaryFade,
        fontSize: AppSizes.textTitle,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    ),
  );
}
