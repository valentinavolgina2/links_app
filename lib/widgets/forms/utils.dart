import 'package:flutter/material.dart';

class FormUtils {
  static InputDecoration inputDecoration(
      {String hintText = '', String? errorText}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blueGrey[800]!,
            width: 3,
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: Colors.blueGrey[300],
        ),
        hintText: hintText,
        fillColor: Colors.white,
        errorText: errorText,
        errorStyle: const TextStyle(
          fontSize: 12,
          color: Colors.redAccent,
        ));
  }

  static BoxConstraints formMaxWidthConstraints() {
    return const BoxConstraints(maxWidth: 300);
  }

  static Widget cancelButton() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
      ),
      child: Text('Cancel'),
    );
  }

  static Widget saveButton() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
      ),
      child: Text('SAVE'),
    );
  }
}
