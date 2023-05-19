import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import '../../connection/authentication.dart';
import '../../model/app.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'google.dart';

class SignupDialog extends StatefulWidget {
  const SignupDialog({super.key});

  @override
  State<SignupDialog> createState() => _SignupDialogState();
}

class _SignupDialogState extends State<SignupDialog> {
  TextEditingController textControllerEmail = TextEditingController();
  FocusNode textFocusNodeEmail = FocusNode();

  TextEditingController textControllerPassword = TextEditingController();
  FocusNode textFocusNodePassword = FocusNode();

  bool _isRegistering = false;

  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  void _signup(BuildContext context) async {
    setState(() {
      _isRegistering = true;
    });

    await registerWithEmailPassword(
            textControllerEmail.text, textControllerPassword.text)
        .then((result) {
      if (result != null) {
        Navigator.of(context).pop();

        SystemMessage.showSuccess(
            context: context, message: 'You have registered successfully.');
      }
    }).catchError((error) {
      setState(() {
        _error = error;
      });
    });

    setState(() {
      _isRegistering = false;
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
                Center(child: Text(AppData.title.toUpperCase(), style: TextStyle(color: AppColors.secondaryColor, fontWeight: FontWeight.w600, letterSpacing: 1.5))),
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
                _error == '' ? const SizedBox() : Padding(
                  padding: EdgeInsets.only(top: AppSizes.medium, bottom: AppSizes.medium),
                  child: Center(child: Text(_error, style: TextStyle(color: AppColors.redText))),
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
                        padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
                        child: FilledButton(
                          onPressed: () => _signup(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppSizes.medium,
                              bottom: AppSizes.medium,
                            ),
                            child: _isRegistering
                                ? SizedBox(
                                    height: AppSizes.medium,
                                    width: AppSizes.medium,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.whiteText,
                                      ),
                                    ),
                                  )
                                : const Text('Sign up'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
