import 'package:flutter/material.dart';

class CardContainerSmWidget extends StatelessWidget {
  final Widget child;

  const CardContainerSmWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: child,
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(5, 5))]);
}
