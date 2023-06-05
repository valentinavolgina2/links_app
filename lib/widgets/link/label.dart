import 'package:flutter/material.dart';

class LinkFormLabel extends StatelessWidget {
  const LinkFormLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text)
    );
  }
}
