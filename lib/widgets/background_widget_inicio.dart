import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackgroundWidgetInicio extends StatefulWidget {
  final Widget child;
  final Widget child2;

  const BackgroundWidgetInicio(
      {Key? key, required this.child, required this.child2})
      : super(key: key);

  @override
  State<BackgroundWidgetInicio> createState() => _BackgroundWidgetInicioState();
}

class _BackgroundWidgetInicioState extends State<BackgroundWidgetInicio> {
  String rfc = '-';
  String nombre = '-';

  @override
  void initState() {
    super.initState();
    //getSharedPrefs().then((value) => null);
    setState(() {});
  }

  // Future<bool> getSharedPrefs() async {
  //   const storage = FlutterSecureStorage();
  //   rfc = await storage.read(key: 'rfc') as String;
  //   nombre = await storage.read(key: 'nombre') as String;
  //   debugPrint('rfc: $rfc');
  //   debugPrint('nombre: $nombre');
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    //final  pantalla = MediaQuery.of(context).size;
    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _CajaNaranja(),
          SafeArea(
              top: true,
              minimum: const EdgeInsets.all(70),
              child: SizedBox(
                  width: double.infinity,
                  height: 73,
                  child: Image.asset('assets/fabes_master.png'))),
          Positioned(
            top: 100,
            child: widget.child2,
          ),
          Stack(children: [
            Positioned(
              top: 400,
              child: widget.child,
            )
          ])
        ],
      ),
    );
  }
}

// Caja naranja y las bolitas
class _CajaNaranja extends StatelessWidget {
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
            Positioned(top: 90, left: 10, child: _Burbuja()),
            Positioned(top: 210, left: 85, child: _Burbuja()),
            Positioned(top: -20, left: pantalla.width / 2, child: _Burbuja()),
            Positioned(top: 230, right: -30, child: _Burbuja()),
            Positioned(top: 30, right: -10, child: _Burbuja()),
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

// Tamano y colores de las burbujas
class _Burbuja extends StatelessWidget {
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
