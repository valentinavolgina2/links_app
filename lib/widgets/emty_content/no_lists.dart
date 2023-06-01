import 'package:flutter/material.dart';

import '../../styles/size.dart';
import '../list/add_dialog.dart';

class NoListsPage extends StatelessWidget {
  const NoListsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const AddListDialog();
                }
              );
            },
            child: const Text('Add List'))
      ]);
  }
}