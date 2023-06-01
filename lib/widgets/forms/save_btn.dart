import 'package:flutter/material.dart';

import '../../styles/size.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSizes.medium,
        bottom: AppSizes.medium,
      ),
      child: const Text('SAVE'),
    );
  }
}