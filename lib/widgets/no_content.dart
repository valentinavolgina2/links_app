import 'package:flutter/material.dart';
import 'package:links_app/widgets/user/signup.dart';

import '../main.dart';
import '../styles/size.dart';

class EmptyContainer {
  static Widget needLogin(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Welcome to My Links', style: TextStyle(fontSize: AppSizes.textTitle)),
        SizedBox(height: AppSizes.medium),
        const Text('Get started by creating a new profile. Only registered users can create list of links.'),
        SizedBox(height: AppSizes.medium),
        FilledButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => const SignupDialog(),
            ).then((result) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage()),
              )
            });
          }, 
          child: const Text('Register'))
      ]
    );
  }
}
