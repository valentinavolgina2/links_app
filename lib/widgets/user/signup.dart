import 'package:flutter/material.dart';
import 'package:links_app/pages/login.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/user/text_field.dart';

import '../../connection/authentication.dart';
import '../../main.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'header.dart';

class SignupDialog extends StatelessWidget {
  SignupDialog({super.key});

  final TextEditingController textControllerEmail = TextEditingController();
  final TextEditingController textControllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.medium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(headerText: 'Create account'),
                  AuthTextField(
                      label: 'Email',
                      fieldType: TextInputType.emailAddress,
                      controller: textControllerEmail),

                  SizedBox(height: AppSizes.medium),
                  AuthTextField(
                      label: 'Password',
                      fieldType: TextInputType.visiblePassword,
                      controller: textControllerPassword),
                  SizedBox(height: AppSizes.medium),
                  SignupButton(emailController: textControllerEmail,
                      passwordController: textControllerPassword),
                  SizedBox(height: AppSizes.small),
                  const LoginInsteadSign()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupButton extends StatefulWidget {
  const SignupButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<SignupButton> {
  String _error = '';
  bool _isRegistering = false;

  void _signup(BuildContext context) async {
    setState(() {
      _isRegistering = true;
    });

    await registerWithEmailPassword(
            widget.emailController.text, widget.passwordController.text)
        .then((result) {
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );

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
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        _error == ''
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.only(
                  top: AppSizes.medium, bottom: AppSizes.medium),
              child: Center(
                  child: Text(_error,
                      style: TextStyle(color: AppColors.redText))),
            ),
        SizedBox(
          width: double.maxFinite,
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          AppColors.whiteText,
                        ),
                      ),
                    )
                  : const Text('Sign up'),
            ),
          ),
        ),
      ]);
  }
}

class LoginInsteadSign extends StatelessWidget {
  const LoginInsteadSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Already have an account?'),
        SizedBox(width: AppSizes.small),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              'Log in',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600)
            )
        )
      ]
    );
  }
}