import 'package:flutter/material.dart';

import '../../styles/size.dart';
import '../forms/add_list_btn.dart';
import '../forms/cancel_btn.dart';
import '../forms/helper.dart';
import '../forms/validation.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addListController = TextEditingController();
    final addListFormKey = GlobalKey<FormState>();

    return Dialog(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.medium),
          child: Form(
              key: addListFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Adding new list',
                      style: TextStyle(fontSize: AppSizes.textTitle)),
                  SizedBox(height: AppSizes.medium),
                  const Text('Name'),
                  SizedBox(height: AppSizes.small),
                  TextFormField(
                    controller: addListController,
                    decoration: FormHelpers.inputDecoration(hintText: 'Name', editingController: addListController),
                    maxLength: listNameMaxLength,
                    validator: (value) => listNameValidator(value),
                  ),
                  SizedBox(height: AppSizes.medium),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const FormCancelButton(),
                        ListAddButton(
                            formKey: addListFormKey,
                            nameController: addListController)
                      ])
                ],
              )),
        ),
      ),
    );
  }
}
