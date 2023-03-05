import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenssagesUI {
  Future<void> displayDialogAndroid(
      BuildContext context, String title, String mensaje) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 4,
            title: Text(title),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mensaje),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'))
            ],
          );
        });
  }

  Future<void> displayDialogIos(
      BuildContext context, String title, String mensaje) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mensaje),
                const SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.transparent),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.transparent),
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.indigo))),
            ],
          );
        });
  }
}
