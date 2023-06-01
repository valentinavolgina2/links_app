import 'package:flutter/material.dart';
import 'package:links_app/model/app.dart';
import 'package:links_app/styles/color.dart';

import '../../connection/authentication.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'google.dart';

class SigninDialog extends StatefulWidget {
  const SigninDialog({super.key});

  @override
  State<SigninDialog> createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  TextEditingController textControllerEmail = TextEditingController();
  FocusNode textFocusNodeEmail = FocusNode();

  TextEditingController textControllerPassword = TextEditingController();
  FocusNode textFocusNodePassword = FocusNode();

  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  void _signin(BuildContext context) async {
    await signInWithEmailPassword(
            textControllerEmail.text, textControllerPassword.text)
        .then((result) {
      if (result != null) {
        Navigator.of(context).pop();

        SystemMessage.showSuccess(context: context, message: 'Welcome back!');
      }
    }).catchError((error) {
      setState(() {
        _error = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSizes.medium),
                Center(
                    child: Text(AppData.title.toUpperCase(),
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5))),
                SizedBox(height: AppSizes.large),
                const Text('Email address'),
                SizedBox(height: AppSizes.medium),
                TextField(
                  focusNode: textFocusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerEmail,
                  autofocus: false,
                  onSubmitted: (value) {
                    textFocusNodeEmail.unfocus();
                    FocusScope.of(context).requestFocus(textFocusNodePassword);
                  },
                  style: TextStyle(color: AppColors.darkText),
                  decoration: FormHelpers.inputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: AppSizes.large),
                const Text('Password'),
                SizedBox(height: AppSizes.medium),
                TextField(
                  focusNode: textFocusNodePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  controller: textControllerPassword,
                  autofocus: false,
                  style: TextStyle(color: AppColors.darkText),
                  decoration: FormHelpers.inputDecoration(hintText: 'Password'),
                ),
                SizedBox(height: AppSizes.medium),
                _error == ''
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: AppSizes.medium, bottom: AppSizes.medium),
                        child: Center(
                            child: Text(_error,
                                style: TextStyle(color: AppColors.redText))),
                      ),
                SizedBox(height: AppSizes.medium),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                            left: AppSizes.small, right: AppSizes.small),
                        child: FilledButton(
                          onPressed: () => _signin(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppSizes.medium,
                              bottom: AppSizes.medium,
                            ),
                            child: const Text('Log in'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: AppSizes.large,
                  thickness: AppSizes.googleBorderWidth,
                  indent: AppSizes.medium,
                  endIndent: AppSizes.medium,
                  color: AppColors.secondaryColor,
                ),
                const Center(child: GoogleButton()),
                // SizedBox(height: AppSizes.medium),
                // Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Text("Don't have an account?"),
                //       SizedBox(width: AppSizes.small),
                //       TextButton(
                //         onPressed: () async {
                //         await showDialog(
                //           context: context,
                //           builder: (context) => const SignupDialog(),
                //         ).then((result) => {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => const MyHomePage()),
                //               )
                //             });
                //       }, 
                //         child: const Text('Register')
                //       )
                //     ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
