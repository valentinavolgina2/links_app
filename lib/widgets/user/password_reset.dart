import 'package:flutter/material.dart';
import 'package:links_app/widgets/user/text_field.dart';

import '../../auth/result_handler.dart';
import '../../connection/authentication.dart';
import '../../main.dart';
import '../../pages/login.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'header.dart';

class PasswordReset extends StatelessWidget {
  PasswordReset({super.key});

  final TextEditingController textControllerEmail = TextEditingController();
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
                  const AuthHeader(headerText: 'Password reset'),
                  AuthTextField(
                      label: 'Email',
                      fieldType: TextInputType.emailAddress,
                      controller: textControllerEmail),
                  SizedBox(height: AppSizes.medium),
                  ResetButton(emailController: textControllerEmail),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetButton extends StatefulWidget {
  const ResetButton({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  String _error = '';
  bool _isResetting = false;

  void _reset(BuildContext context) async {
    setState(() {
      _isResetting = true;
    });

  await resetPassword(email: widget.emailController.text)
    .then((result) {
      if (result == AuthStatus.successful) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        SystemMessage.showSuccess(
            context: context, message: 'You have reset your password.');
      } else {
        final error = AuthExceptionHandler.generateErrorMessage(result);
        setState(() {
          _error = error;
        });
      }
    });

    setState(() {
      _isResetting = false;
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
          onPressed: () => _reset(context),
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSizes.medium,
              bottom: AppSizes.medium,
            ),
            child: _isResetting
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
                : const Text('Recover password'),
          ),
        ),
      ),
    ]);
  }
}
