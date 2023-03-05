// Tamano y colores de las burbujas
import 'package:flutter/material.dart';

class Burbuja extends StatelessWidget {
  const Burbuja({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(76, 74, 73, 0.106)),
    );
  }
}
