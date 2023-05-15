import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';

import '../connection/authentication.dart';
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

  static const double space20 = 20.0;
  static const double space40 = 40.0;

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20.0),
                const Text('Email address'),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: space40),
                const Text('Password'),
                const SizedBox(height: space20),
                TextField(
                  focusNode: textFocusNodePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  controller: textControllerPassword,
                  autofocus: false,
                  style: TextStyle(color: AppColors.darkText),
                  decoration: FormUtils.inputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: space20),
                _error == '' ? const SizedBox() : Padding(
                  padding: const EdgeInsets.only(top: space20, bottom: space20),
                  child: Center(child: Text(_error, style: TextStyle(color: AppColors.redText))),
                ),
                const SizedBox(height: space20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: FilledButton(
                          onPressed: () => _signin(context),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                            ),
                            child: Text('Sign in'),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: FilledButton(
                          onPressed: () => _signup(context),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                            ),
                            child: _isRegistering
                                ? SizedBox(
                                    height: 16,
                                    width: 16,
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
