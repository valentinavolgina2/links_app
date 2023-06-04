import 'package:flutter/material.dart';
import 'package:links_app/model/app.dart';

import '../../styles/size.dart';

class NoPasswordChange extends StatelessWidget {
  const NoPasswordChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: AppSizes.listMaxWidth),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No change password for this account', style: TextStyle(fontSize: AppSizes.textTitle)),
              SizedBox(height: AppSizes.medium),
              Text('You used your Google account to sign up to ${AppData.title}. This means you can change your password only through Google. Once you have done this, log in to your ${AppData.title} account using your new login credentials.', textAlign: TextAlign.center,),
            ]),
      ),
    );
  }
}
