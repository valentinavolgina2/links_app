import 'package:flutter/material.dart';

import '../connection/authentication.dart';
import '../main.dart';
import '../model/app.dart';
import '../styles/color.dart';
import '../styles/size.dart';
import 'auth_dialog.dart';
import 'message.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _isProcessing = false;

  _signout() async {
    setState(() {
      _isProcessing = true;
    });

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

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.medium),
        child: Row(
          children: [
            Expanded(
                child: Text(AppData.title.toUpperCase(),
                    style: TextStyle(color: AppColors.whiteText))),
            InkWell(
                onTap: userEmail == null
                    ? () async {
                        await showDialog(
                          context: context,
                          builder: (context) => const AuthDialog(),
                        ).then((result) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage()),
                          )
                        });
                      }
                    : null,
                child: userEmail == null
                    ? Text('Sign in',
                        style: TextStyle(
                          color: AppColors.whiteText,
                        ))
                    : Row(children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl!) : null,
                          child: imageUrl == null
                              ? const Icon(Icons.account_circle, size: 30)
                              : Container(),
                        ),
                        Text(userEmail!,
                            style: TextStyle(
                              color: AppColors.whiteText,
                            )),
                        SizedBox(width: AppSizes.medium),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                            ),
                            onPressed: _isProcessing ? null : () => _signout(),
                            child: _isProcessing
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Sign out',
                                    style: TextStyle(
                                      color: AppColors.whiteText,
                                    ),
                                  ))
                      ])),
          ],
        ),
      ),
    );
  }
}
