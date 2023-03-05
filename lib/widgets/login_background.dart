import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final  pantalla = MediaQuery.of(context).size;

    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const ContenedorColor(),
          SafeArea(
              top: true,
              minimum: const EdgeInsets.all(60),
              child: SizedBox(
                  width: double.infinity,
                  height: 73,
                  child: Image.asset('assets/fabes_master.png'))),
          const Positioned(
              top: 150,
              left: 170,
              child: Icon(Icons.lock_person,
                  color: Color.fromRGBO(255, 102, 0, 1), size: 40)),
          child,
        ],
      ),
    );
  }
}
