import 'package:flutter/material.dart';

import '../../connection/authentication.dart';
import '../../model/app.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import 'helper.dart';
import 'menu.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.medium),
        child: const Row(
          children: [
            Expanded(
              child: MainPageMenu()
            ),
            LoginMenu(),
            RegisterMenu(),
            LoggedInUserMenu(),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Divider _divider() {
    return Divider(
      height: AppSizes.large,
      thickness: AppSizes.googleBorderWidth,
      indent: 0,
      endIndent: 0,
      color: AppColors.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: AppColors.primaryColor,
            child: Padding(
                padding: EdgeInsets.all(AppSizes.medium),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(AppData.title.toUpperCase(),
                            style: TextStyle(
                                color: AppColors.whiteText,
                                letterSpacing: 1.5,
                                fontSize: AppSizes.textTitle)),
                      ),
                      _divider(),
                      userEmail == null
                        ? Container(
                            width: double.maxFinite,
                            child: const LoginMenu(mobile: true))
                        : Row(children: [
                            avatar(),
                            const UsernameMenu(),
                          ]),
                        _divider(),
                        Container(
                            width: double.maxFinite,
                            child: userEmail == null ? const RegisterMenu(mobile: true) : const SignOutMenu(mobile: true))
                    ]))));
  }
}
