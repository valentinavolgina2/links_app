import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';

import '../../connection/authentication.dart';
import '../../main.dart';

class GoogleButton
 extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.googleButtonRadius),
          side: BorderSide(color: AppColors.secondaryColor, width: AppSizes.googleBorderWidth),
        ),
        color: AppColors.whiteText,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.googleButtonRadius),
            side: BorderSide(color: AppColors.secondaryColor, width: AppSizes.googleBorderWidth),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          setState(() {
            _isProcessing = true;
          });
          await signInWithGoogle().then((result) {
            debugPrint(result.toString());
            if (result != null) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const MyHomePage(),
                ),
              );
            }
          }).catchError((error) {
            debugPrint('Registration Error: $error');
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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