import 'package:fabes/widgets/fondo/contenedor_color.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackgroundWidget extends StatefulWidget {
  final Widget child;
  final Widget child2;
  final double topChild2;
  final double topLogo;

  const BackgroundWidget({Key? key, required this.child, required this.child2, required this.topChild2, required this.topLogo}) : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  String rfc = '-';
  String nombre = '-';

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const ContenedorColor(),
        Positioned(
          top: widget.topLogo,
          child: Image.asset('assets/fabes_master.png', height: 70),
        ),
        Positioned(
            top: widget.topChild2,
            //child: Align(alignment: Alignment.center, child: widget.child2),
            child: widget.child2),
        widget.child,
      ],
    );
    // return SizedBox(
    //   //color: Colors.red,
    //   width: /double.maxFinite,
    //   height: /double.maxFinite,
    //   child: Stack(
    //     children: [
    //       const ContenedorColor(),
    //       SafeArea(top: true, minimum: const EdgeInsets.all(10), child: SizedBox(width: double.infinity, height: 73, child: Image.asset('assets/fabes_master.png'))),
    //       Positioned(
    //         top: widget.topChild2,
    //         child: widget.child2,
    //       ),
    //       widget.child,
    //     ],
    //   ),
    // );
  }
}
