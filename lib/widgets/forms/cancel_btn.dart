import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../../styles/size.dart';

class FormCancelButton extends StatelessWidget {
  const FormCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: AppSizes.small, right: AppSizes.small),
        child: FilledButton(
          style:
              FilledButton.styleFrom(backgroundColor: AppColors.secondaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSizes.medium,
              bottom: AppSizes.medium,
            ),
            child: const Text('Cancel'),
          ),
        ),
      ),
    );
  }
}
