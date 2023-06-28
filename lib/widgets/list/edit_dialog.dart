import 'package:flutter/material.dart';

import '../../model/list.dart';
import '../../styles/size.dart';
import '../forms/cancel_btn.dart';
import '../forms/helper.dart';
import '../forms/update_list_btn.dart';
import '../forms/validation.dart';

class EditListDialog extends StatelessWidget {
  const EditListDialog({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    final TextEditingController editNameController = TextEditingController();
    editNameController.text = list.name;

    final formKey = GlobalKey<FormState>();

    return Dialog(
      child: Container(
        constraints: FormHelpers.formMaxWidthConstraints(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.medium),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit list name',
                    style: TextStyle(fontSize: AppSizes.textTitle)),
                SizedBox(height: AppSizes.medium),
                TextFormField(
                  controller: editNameController,
                  decoration: FormHelpers.inputDecoration(hintText: 'Name', editingController: editNameController),
                  maxLength: listNameMaxLength,
                  validator: (value) => listNameValidator(value),
                ),
                SizedBox(height: AppSizes.medium),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const FormCancelButton(),
                    ListUpdateButton(
                      list: list, 
                      formKey: formKey, 
                      editNameController: editNameController
                    )
                  ]
                )
              ],
            )),
        ),
      ),
    );
  }
}
