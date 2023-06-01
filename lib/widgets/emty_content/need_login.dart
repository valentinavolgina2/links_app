import 'package:flutter/material.dart';

import '../../main.dart';
import '../../styles/size.dart';
import '../user/login.dart';
import '../user/signup.dart';

class NeedLoginPage extends StatelessWidget {
  const NeedLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Welcome to My Links',
          style: TextStyle(fontSize: AppSizes.textTitle)),
      SizedBox(height: AppSizes.medium),
      const Text(
        'Get started by creating a new profile. Only registered users can create list of links.',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: AppSizes.medium),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: FilledButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const SigninDialog(),
              ).then((result) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    )
                  });
            },
            child: const Text('Login'),
          )),
          SizedBox(width: AppSizes.medium),
          Flexible(
              child: FilledButton(
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
            child: const Text('Register'),
          ))
        ],
      )
    ]);
  }
}