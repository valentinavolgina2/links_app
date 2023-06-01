import 'package:flutter/material.dart';

import '../../connection/authentication.dart';
import '../../main.dart';
import '../../model/app.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../message.dart';
import '../user/login.dart';
import '../user/signup.dart';
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
            ? () async {
                await showDialog(
                  context: context,
                  builder: (context) => const SigninDialog(),
                ).then((result) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      )
                    });
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
            ? () async {
                await showDialog(
                  context: context,
                  builder: (context) => const SignupDialog(),
                ).then((result) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      )
                    });
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

  @override
  Widget build(BuildContext context) {
    return userEmail == null
        ? const SizedBox(width: 0)
        : Row(children: [
            avatar(),
            const UsernameMenu(),
            SizedBox(width: AppSizes.medium),
            const SignOutMenu()
          ]);
  }
}

class SignOutMenu extends StatelessWidget {
  const SignOutMenu({super.key, this.mobile = false});

  final bool mobile;

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

  @override
  Widget build(BuildContext context) {
    final textStyle = mobile
        ? TextStyle(fontSize: AppSizes.textTitle, color: AppColors.whiteText)
        : TextStyle(color: AppColors.whiteText);
        
    return mobile
    ? InkWell(
      onTap: () => _signout(context),
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSizes.small,
          bottom: AppSizes.small,
        ),
        child: Text(
          'Sign out',
          style: textStyle,
        ),
      ),
    )
    : TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
      ),
      onPressed: () => _signout(context),
      child: Text(
        'Sign out',
        style: textStyle,
      ));
  }
}


