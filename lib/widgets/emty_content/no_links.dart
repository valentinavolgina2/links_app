import 'package:flutter/material.dart';
import 'package:links_app/model/list.dart';

import '../../styles/size.dart';
import '../link/add_dialog.dart';

class NoLinksPage extends StatelessWidget {
  const NoLinksPage({super.key, required this.list});

  final LinksList list;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Links', style: TextStyle(fontSize: AppSizes.textTitle)),
          SizedBox(height: AppSizes.medium),
          const Text('There are no links added to this list'),
          SizedBox(height: AppSizes.medium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible:
                              false, // user must tap button for close dialog!
                          builder: (BuildContext context) {
                            return LinkAddDialog(list: list);
                          });
                    },
                    child: const Text('Add Link')),
              ),
              SizedBox(width: AppSizes.medium),
              Flexible(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to lists'),
                ),
              ),
            ],
          )
        ]);
  }
}
