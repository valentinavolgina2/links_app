import 'package:flutter/material.dart';

import '../../pages/login.dart';
import '../../pages/register.dart';
import '../../styles/size.dart';

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
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Login'),
          )),
          SizedBox(width: AppSizes.medium),
          Flexible(
            child: FilledButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Register'),
            )
          )
        ],
      )
    ]);
  }
}