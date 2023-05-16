import 'package:flutter/material.dart';
import 'package:links_app/widgets/user/signup.dart';

import '../main.dart';
import '../model/list.dart';
import '../styles/size.dart';
import 'forms/helper.dart';

class EmptyContainer {
  static Widget needLogin(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Welcome to My Links',
              style: TextStyle(fontSize: AppSizes.textTitle)),
          SizedBox(height: AppSizes.medium),
          const Text(
              'Get started by creating a new profile. Only registered users can create list of links.'),
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
        ]);
  }

  static Widget noLinksAdded({required BuildContext context, required LinksList list}) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Links', style: TextStyle(fontSize: AppSizes.textTitle)),
          SizedBox(height: AppSizes.medium),
          const Text('There are no links added to this list'),
          SizedBox(height: AppSizes.medium),
          FilledButton(
              onPressed: () =>
                  FormHelpers.addLink(context: context, list: list),
              child: const Text('Add Link'))
        ]);
  }

  static Widget noListsAdded({required BuildContext context, required String userId}) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Lists', style: TextStyle(fontSize: AppSizes.textTitle)),
          SizedBox(height: AppSizes.medium),
          const Text('There are no lists added to this profile'),
          SizedBox(height: AppSizes.medium),
          FilledButton(
              onPressed: () =>
                  FormHelpers.addList(context: context, userId: userId),
              child: const Text('Add List'))
        ]);
  }
}
