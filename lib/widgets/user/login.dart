import 'package:flutter/material.dart';
import 'package:links_app/main.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/user/text_field.dart';

import '../../connection/authentication.dart';
import '../../pages/register.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'divider.dart';
import 'facebook.dart';
import 'google.dart';
import 'header.dart';

class SigninDialog extends StatelessWidget {
  SigninDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController textControllerEmail = TextEditingController();
  final TextEditingController textControllerPassword = TextEditingController();

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
                  const AuthHeader(headerText: 'Welcome back!'),
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
                  LoginButton(
                      emailController: textControllerEmail,
                      passwordController: textControllerPassword),
                  const LoginDivider(),
                  const Center(child: GoogleButton()),
                  SizedBox(height: AppSizes.small),
                  const Center(child: FacebookButton()),
                  SizedBox(height: AppSizes.small),
                  const RegisterInsteadSign()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  String _error = '';

  void _signin(BuildContext context) async {
    await signInWithEmailPassword(
            widget.emailController.text, widget.passwordController.text)
        .then((result) {
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );

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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _error == ''
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.only(
                  top: AppSizes.medium, bottom: AppSizes.medium),
              child: Center(
                  child:
                      Text(_error, style: TextStyle(color: AppColors.redText))),
            ),
      SizedBox(
        width: double.maxFinite,
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
    ]);
  }
}

class RegisterInsteadSign extends StatelessWidget {
  const RegisterInsteadSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Don't have an account?"),
          SizedBox(width: AppSizes.small),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w600)
              )
          )
        ]);
  }
}
