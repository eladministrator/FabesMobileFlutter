import 'package:fabes/theme/app_theme.dart';
import 'package:fabes/theme/bearer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../arguments/bearer_args.dart';

class MenssagesActivacionUI {
  //INFO: Mensajes para android
  Future<void> displayDialogAndroid(
      BuildContext context, String rfc, String correo, String celular, String nombre) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 4,
            title: const Text(GlobalTextsApp.tagMsgActivacion),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  GlobalTextsApp.tagMsgActDescripcion,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, 'activar',
                      arguments: ActivacionCuentaSmsArgs(
                          rfc: rfc, nombre: nombre, celular: celular, correo: correo)),
                  child: const Text('Aceptar',
                      style: TextStyle(fontSize: 17, color: AppTheme.btnAceptar))),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar',
                      style: TextStyle(fontSize: 17, color: AppTheme.btnCancelar)))
            ],
          );
        });
  }

  //INFO: Mensajes para IOS
  Future<void> displayDialogIos(
      BuildContext context, String rfc, String correo, String celular, String nombre) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(GlobalTextsApp.tagMsgActivacion),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(GlobalTextsApp.tagMsgActDescripcion),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, 'activar',
                      arguments: ActivacionCuentaSmsArgs(
                          rfc: rfc, nombre: nombre, celular: celular, correo: correo)),
                  child: const Text('Aceptar',
                      style: TextStyle(fontSize: 17, color: AppTheme.btnAceptar))),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar',
                      style: TextStyle(fontSize: 17, color: AppTheme.btnCancelar)))
              //INFO: Codigo de los botones originales
              // TextButton(
              //     onPressed: () => Navigator.pop(context),
              //     style: TextButton.styleFrom(
              //         primary: Colors.black, backgroundColor: Colors.transparent),
              //     child: const Text('Cancelar', style: TextStyle(color: Colors.red))),
              // TextButton(
              //     onPressed: () => Navigator.pop(context),
              //     style: TextButton.styleFrom(
              //         primary: Colors.black, backgroundColor: Colors.transparent),
              //     child: const Text('Aceptar', style: TextStyle(color: Colors.indigo))),
            ],
          );
        });
  }
}
