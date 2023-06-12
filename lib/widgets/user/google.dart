import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';

import '../../auth/result_handler.dart';
import '../../connection/authentication.dart';
import '../../main.dart';
import '../message.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.whiteText),
        borderRadius: BorderRadius.circular(AppSizes.googleButtonRadius),
        color: AppColors.lightGrey
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.googleButtonRadius),
            side: BorderSide(
                color: AppColors.secondaryColor,
                width: AppSizes.googleBorderWidth),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          setState(() {
            _isProcessing = true;
          });
          
          await signInWithGoogle().then((result) {
            if (result == AuthStatus.successful) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const MyHomePage(),
                ),
              );
            } else {
              SystemMessage.showError(
                context: context, message: AuthExceptionHandler.generateErrorMessage(result));
            }
          });

          setState(() {
            _isProcessing = false;
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, AppSizes.small, 0, AppSizes.small),
          child: _isProcessing
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.secondaryColor,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: const AssetImage("assets/images/google_logo.png"),
                      height: AppSizes.large,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.small),
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
