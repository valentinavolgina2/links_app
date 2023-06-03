import 'package:flutter/material.dart';
import 'package:links_app/main.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/widgets/user/text_field.dart';

import '../../connection/authentication.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import '../message.dart';
import 'header.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController textControllerPassword = TextEditingController();
  final TextEditingController textControllerNewPassword = TextEditingController();

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
                  const AuthHeader(headerText: 'Change password'),
                  AuthTextField(
                      label: 'Current password',
                      fieldType: TextInputType.visiblePassword,
                      controller: textControllerPassword),
                  SizedBox(height: AppSizes.medium),
                  AuthTextField(
                      label: 'New password',
                      fieldType: TextInputType.visiblePassword,
                      controller: textControllerNewPassword),
                  SizedBox(height: AppSizes.medium),
                  UpdatePasswordButton(
                      passwordController: textControllerPassword,
                      newPasswordController: textControllerNewPassword),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpdatePasswordButton extends StatefulWidget {
  const UpdatePasswordButton(
      {super.key,
      required this.passwordController,
      required this.newPasswordController});

  final TextEditingController passwordController;
  final TextEditingController newPasswordController;

  @override
  State<UpdatePasswordButton> createState() => _UpdatePasswordButtonState();
}

class _UpdatePasswordButtonState extends State<UpdatePasswordButton> {
  String _error = '';

  void _update(BuildContext context) async {
    await changePassword(currentPassword: widget.passwordController.text, newPassword: widget.newPasswordController.text)
        .then((result) {
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );

        SystemMessage.showSuccess(context: context, message: 'Password was updated.');
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
          onPressed: () => _update(context),
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSizes.medium,
              bottom: AppSizes.medium,
            ),
            child: const Text('Update'),
          ),
        ),
      ),
    ]);
  }
}
