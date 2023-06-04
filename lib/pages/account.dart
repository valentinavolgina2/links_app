import 'package:flutter/material.dart';

import '../connection/authentication.dart';
import '../widgets/app_bar/app_bar.dart';
import '../widgets/app_bar/helper.dart';
import '../widgets/emty_content/no_password_change.dart';
import '../widgets/responsive.dart';
import '../widgets/user/edit.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? smallScreenAppBar()
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: const MyAppBar()),
      drawer: const MyDrawer(),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: signedInWithSocial 
          ? const NoPasswordChange()
          : MyAccount(),
        );
      }),
    );
  }
}
