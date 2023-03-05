import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(239, 65, 53, 1);
  static const Color enabledBorderColor = Color.fromARGB(255, 201, 203, 207);
  static const Color focusedBorderColor = Color.fromARGB(255, 229, 148, 164);
  static const Color primaryText = Color.fromARGB(255, 83, 60, 73);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color btnCancelar = Color.fromARGB(255, 253, 0, 0);
  static const Color btnDefault = Color.fromARGB(255, 118, 88, 68);
  static const Color btnPrincipal = Color.fromRGBO(255, 102, 0, 1);
  static const Color btnAceptar = Color.fromARGB(255, 55, 179, 51);

  // static ThemeData lightTheme = ThemeData.light().copyWith(
  //     appBarTheme: const AppBarTheme(color: primary, elevation: 1, centerTitle: true),
  //     iconTheme: const IconThemeData(
  //       color: primary,
  //       size: 30,
  //     ),
  //     textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: white, backgroundColor: primary)),
  //     cardTheme: const CardTheme(elevation: 3),
  //     // FloatingActionButtons
  //     floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primary, elevation: 2),
  //     // ElevatedButtons
  //     elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: primary, shape: const StadiumBorder(), elevation: 2)),
  //     inputDecorationTheme: const InputDecorationTheme(
  //         suffixIconColor: primary,
  //         floatingLabelStyle: TextStyle(color: primaryText),
  //         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: enabledBorderColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10))),
  //         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focusedBorderColor), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10))),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10)))));
}
