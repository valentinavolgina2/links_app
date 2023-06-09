import 'package:flutter/material.dart';

import '../widgets/app_bar/app_bar.dart';
import '../widgets/app_bar/helper.dart';
import '../widgets/responsive.dart';
import '../widgets/user/password_reset.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

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
        return const SafeArea(
          child: PasswordReset(),
        );
      }),
    );
  }
}