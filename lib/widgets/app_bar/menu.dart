import 'package:flutter/material.dart';

import '../../connection/authentication.dart';
import '../../main.dart';
import '../../model/app.dart';
import '../../pages/account.dart';
import '../../pages/login.dart';
import '../../pages/register.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../message.dart';
import 'helper.dart';

class MainPageMenu extends StatelessWidget {
  const MainPageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      },
      child: Text(AppData.title.toUpperCase(),
          style: TextStyle(color: AppColors.whiteText, letterSpacing: 1.5)),
    );
  }
}

class LoginMenu extends StatelessWidget {
  const LoginMenu({super.key, this.mobile = false});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final padding = mobile
        ? EdgeInsets.only(top: AppSizes.small, bottom: AppSizes.small)
        : EdgeInsets.only(right: AppSizes.medium);

    final textStyle = mobile
        ? TextStyle(fontSize: AppSizes.textTitle, color: AppColors.whiteText)
        : TextStyle(color: AppColors.whiteText);

    return InkWell(
        onTap: userEmail == null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            : null,
        child: userEmail == null
            ? Padding(
                padding: padding,
                child: Text('Login', style: textStyle),
              )
            : const SizedBox(width: 0));
  }
}

class RegisterMenu extends StatelessWidget {
  const RegisterMenu({super.key, this.mobile = false});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final padding = mobile
        ? EdgeInsets.only(top: AppSizes.small, bottom: AppSizes.small)
        : EdgeInsets.only(right: AppSizes.medium);

    final textStyle = mobile
        ? TextStyle(fontSize: AppSizes.textTitle, color: AppColors.whiteText)
        : TextStyle(color: AppColors.whiteText);

    return InkWell(
        onTap: userEmail == null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              }
            : null,
        child: userEmail == null
            ? Padding(
                padding: padding,
                child: Text('Sign up', style: textStyle),
              )
            : const SizedBox(width: 0));
  }
}

class LoggedInUserMenu extends StatelessWidget {
  const LoggedInUserMenu({super.key});

  _signout(BuildContext context) async {
    await signOut().then((result) {
      SystemMessage.showSuccess(
          context: context, message: 'You have signed out successfully.');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }).catchError((error) {
      SystemMessage.showError(
          context: context, message: 'Sign Out Error: $error');
    });
  }

  _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return userEmail == null
        ? const SizedBox(width: 0)
        : PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Change password"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Sign out'), Icon(Icons.logout_rounded)]),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 1) {
                _openProfile(context);
              } else if (value == 2) {
                _signout(context);
              }
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  avatar(),
                  const UsernameMenu(),
                ]),
                icon: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: AppColors.whiteText,
                ),
                onPressed: null,
              ),
            ),
          );
  }
}
