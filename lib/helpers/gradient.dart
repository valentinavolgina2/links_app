import 'dart:math';

import 'package:flutter/material.dart';

const gradients = [
  {'begin': Alignment.topLeft, 'end': Alignment.bottomRight},
  {'begin': Alignment.topRight, 'end': Alignment.bottomLeft},
  {'begin': Alignment.centerLeft, 'end': Alignment.centerRight},
  {'begin': Alignment.centerRight, 'end': Alignment.centerLeft},
];

double randomGradientStart() {
  Random random = Random();
  int randomNumber = random.nextInt(5) + 3; // [3,7]
  return randomNumber / 10;
}

Map<String, Alignment> randomGradient() {
  Random random = Random();
  final gradientIdx = random.nextInt(gradients.length); // [0,3]

  return gradients[gradientIdx];
}
