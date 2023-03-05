import 'package:flutter/material.dart';

class InputDecorationsUI {
  static InputDecoration loginInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 3)),
      focusColor: const Color.fromRGBO(255, 102, 0, 1),
      hoverColor: const Color.fromRGBO(255, 102, 0, 1),
      hintText: hintText,

      hintStyle: const TextStyle(color: Color.fromRGBO(224, 215, 215, 1)),
      labelText: labelText,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 90, 71, 63)),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: const Color.fromRGBO(255, 102, 0, 1))
          : null,
    );
  }
}
