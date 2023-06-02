import 'package:flutter/material.dart';
import 'package:links_app/styles/color.dart';
import 'package:links_app/styles/size.dart';

import '../../connection/authentication.dart';
import '../../main.dart';

class FacebookButton extends StatefulWidget {
  const FacebookButton({super.key});

  @override
  State<FacebookButton> createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
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
          await signInWithFacebook().then((result) {
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: const AssetImage("assets/images/facebook_logo.png"),
                      height: AppSizes.large,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.small),
                      child: Text(
                        'Continue with Facebook',
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
