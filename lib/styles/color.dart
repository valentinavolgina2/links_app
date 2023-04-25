import 'package:flutter/material.dart';

/// An app colors grouped by widgets
class AppColors {
  static _Scaffold scaffold = _Scaffold();
  static _Button button = _Button();
  static _Link link = _Link();
  static _Category category = _Category();
}

/// A scaffold group of colors
class _Scaffold {
  MaterialColor? primary = createMaterialColor(const Color(0xff1b434d));
}

/// A button group of colors
class _Button {
  Color? reset = Colors.amber[600];
}

/// A link group of colors
class _Link {
  Color? background = Colors.deepOrange[50];
  Color text = Colors.black87;
}

/// A category group of colors
class _Category {
  Color text = Colors.black87;
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });

  return MaterialColor(color.value, swatch);
}
