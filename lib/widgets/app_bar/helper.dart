import 'package:flutter/material.dart';

import '../../connection/authentication.dart';
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

CircleAvatar avatar() {
  return CircleAvatar(
    radius: 15,
    backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
    child: imageUrl == null
        ? const Icon(Icons.account_circle, size: 30)
        : Container(),
  );
}

class UsernameMenu extends StatelessWidget {
  const UsernameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      userEmail!,
      style: TextStyle(
        color: AppColors.whiteText,
      )
    );
  }
}
