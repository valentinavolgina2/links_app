import 'package:flutter/material.dart';

import '../connection/authentication.dart';
import '../main.dart';
import '../model/app.dart';
import '../styles/color.dart';
import 'auth_dialog.dart';
import 'message.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _isProcessing = false;

  // @override
  // void initState() {
  //   setState(() {});

  //   print('building app bar for user $uid');

  //   super.initState();
  // }

  _signout() async {
    setState(() {
      _isProcessing = true;
    });

    await signOut().then((result) {
      SystemMessage.showSuccess(
          context: context, message: 'You have signed out successfully.');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
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
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: AppColors.scaffold.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: Text(AppData.title.toUpperCase(),
                    style: TextStyle(color: Colors.white))),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       InkWell(
            //         onTap: () {},
            //         child: const Text(
            //           'Home',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //       // SizedBox(width: screenSize.width / 20),
            //       // InkWell(
            //       //   onTap: () {},
            //       //   child: const Text(
            //       //     'Contact Us',
            //       //     style: TextStyle(color: Colors.black),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            InkWell(
                onTap: userEmail == null
                    ? () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AuthDialog(),
                        ).then((result) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          )
                        });
                      }
                    : null,
                child: userEmail == null
                    ? const Text('Sign in',
                        style: TextStyle(
                          color: Colors.white,
                        ))
                    : Row(children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl!) : null,
                          child: imageUrl == null
                              ? Icon(Icons.account_circle, size: 30)
                              : Container(),
                        ),
                        Text(userEmail!,
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        const SizedBox(width: 20.0),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: _isProcessing ? null : () => _signout(),
                            child: _isProcessing
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Sign out',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                      ])),
          ],
        ),
      ),
    );
  }
}
