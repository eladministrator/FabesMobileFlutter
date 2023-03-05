// Caja naranja y las bolitas
import 'package:fabes/widgets/fondo/burbuja_fondo.dart';
import 'package:flutter/material.dart';

class ContenedorColor extends StatelessWidget {
  const ContenedorColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final pantalla = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: pantalla.height,
        decoration: _cajaNaranjaDecoration(),
        child: Stack(
          children: [
            const Positioned(top: 90, left: 10, child: Burbuja()),
            const Positioned(top: 210, left: 85, child: Burbuja()),
            Positioned(
                top: -20, left: pantalla.width / 2, child: const Burbuja()),
            const Positioned(top: 230, right: -30, child: Burbuja()),
            const Positioned(top: 30, right: -10, child: Burbuja()),
          ],
        ));
  }

  // Degradado de la caja superior
  BoxDecoration _cajaNaranjaDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        // Color.fromRGBO(255, 102, 0, 1),
        Color.fromARGB(255, 255, 196, 156),
        Color.fromARGB(255, 251, 220, 199),
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
        // Color.fromRGBO(255, 255, 255, 1),
      ]));
}
