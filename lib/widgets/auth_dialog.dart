import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import '../connection/authentication.dart';
import '../styles/size.dart';
import 'forms/utils.dart';
import 'message.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;

  bool _isRegistering = false;

  late String _error;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerEmail.text = '';
    textFocusNodeEmail = FocusNode();

    textControllerPassword = TextEditingController();
    textControllerEmail.text = '';
    textFocusNodePassword = FocusNode();

    _error = '';

    super.initState();
  }

  String? _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
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
        _error = 'Error occured while registering: $error';
      });
    });

    setState(() {
      _isRegistering = false;
    });
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
        _error = 'Authentication Error: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: FormUtils.formMaxWidthConstraints(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSizes.medium),
                const Text('Email address'),
                SizedBox(height: AppSizes.medium),
                TextField(
                  focusNode: textFocusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerEmail,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      _isEditingEmail = true;
                    });
                  },
                  onSubmitted: (value) {
                    textFocusNodeEmail.unfocus();
                    FocusScope.of(context).requestFocus(textFocusNodePassword);
                  },
                  style: TextStyle(color: AppColors.darkText),
                  decoration: FormUtils.inputDecoration(
                    hintText: 'Email', 
                    errorText: _isEditingEmail
                        ? _validateEmail(textControllerEmail.text)
                        : null),
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
                  decoration: FormUtils.inputDecoration(hintText: 'Password'),
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
                          onPressed: () => _signin(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppSizes.medium,
                              bottom: AppSizes.medium,
                            ),
                            child: const Text('Sign in'),
                          ),
                        ),
                      ),
                    ),
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
                //Center(child: GoogleButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
