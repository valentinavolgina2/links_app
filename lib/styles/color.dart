import 'package:flutter/material.dart';

/// An app colors grouped by widgets
class AppColors {
  static MaterialColor? primaryColor =
      createMaterialColor(const Color(0xff1b434d));
  static Color secondaryColor = Colors.blueGrey;
  static Color pinkBackground = Colors.deepOrange[50]!;
  static Color redBackground = Colors.red[400]!;

  static Color darkText = Colors.black87;
  static Color whiteText = Colors.white;
  static Color redText = Colors.redAccent;

  static Color inputBorder = Colors.blueGrey[800]!;
  static Color fadeText = Colors.blueGrey[300]!;
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
