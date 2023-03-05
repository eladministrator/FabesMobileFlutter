import 'package:fabes/widgets/fondo/contenedor_color.dart';
import 'package:flutter/material.dart';

class BackgroundOnlyWidget extends StatefulWidget {
  final Widget child;
  final Widget child2;
  final double topChild2;
  final double topLogo;

  const BackgroundOnlyWidget({Key? key, required this.child, required this.child2, required this.topChild2, required this.topLogo}) : super(key: key);

  @override
  State<BackgroundOnlyWidget> createState() => _BackgroundOnlyWidgetState();
}

class _BackgroundOnlyWidgetState extends State<BackgroundOnlyWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
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
  }
}
