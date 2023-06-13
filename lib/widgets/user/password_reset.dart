import 'package:flutter/material.dart';
import 'package:links_app/widgets/user/text_field.dart';

import '../../auth/result_handler.dart';
import '../../connection/authentication.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../forms/helper.dart';
import 'header.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController textControllerEmail = TextEditingController();
  final ValueNotifier<String> _resetMessage = ValueNotifier<String>('');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    _resetMessage.addListener(() {
      setState(() {});
    });
  }

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
              child: _resetMessage.value != ''
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(headerText: 'Password reset'),
                        Text(
                          'A link to reset your password has been sent to ${_resetMessage.value} and should be arriving shortly. If it does not arrive in your inbox, check your spam folder.',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.large),
                        const Text('Still haven\'t recieved the link?'),
                        SizedBox(height: AppSizes.small),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _resetMessage.value = '';
                            });
                          },
                          child: Text('Let\'s try one more time',
                              style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(headerText: 'Password reset'),
                        AuthTextField(
                            label: 'Email',
                            fieldType: TextInputType.emailAddress,
                            controller: textControllerEmail),
                        SizedBox(height: AppSizes.medium),
                        ResetButton(
                            emailController: textControllerEmail,
                            resetMessage: _resetMessage),
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
  const ResetButton(
      {super.key, required this.emailController, required this.resetMessage});

  final TextEditingController emailController;
  final ValueNotifier<String> resetMessage;

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  String _error = '';
  bool _isResetting = false;

  void _reset() async {
    setState(() {
      _isResetting = true;
    });

    final result =
        await signedInWithPassword(email: widget.emailController.text);
    if (result != AuthStatus.successful) {
      setState(() {
        widget.resetMessage.value = '';
        _error = AuthExceptionHandler.generateErrorMessage(result);
        _isResetting = false;
      });

      return;
    }

    await resetPassword(email: widget.emailController.text).then((result) {
      if (result == AuthStatus.successful) {
        setState(() {
          widget.resetMessage.value = widget.emailController.text;
          _error = '';
        });
      } else {
        final error = AuthExceptionHandler.generateErrorMessage(result);
        setState(() {
          widget.resetMessage.value = '';
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
          onPressed: () => _reset(),
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
