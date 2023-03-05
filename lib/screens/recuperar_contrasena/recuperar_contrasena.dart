// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparisonimport 'package:fabes/ui/update_app_ui.dart';
import 'package:fabes/providers/recuperar_contrasena_form_provider.dart';
import 'package:fabes/utils/bearer_utils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/ui/bearer_ui.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  const RecuperarContrasenaScreen({Key? key}) : super(key: key);
  @override
  State<RecuperarContrasenaScreen> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasenaScreen> {
  final LocalAuthentication auth = LocalAuthentication(); // instanciar paquete de autenticacion

  String? nombre = '';
  String? rfc = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //MenssagesUI menssagesUI = MenssagesUI();

    return WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          return false;
        },
        child:  Scaffold(
        backgroundColor: Colors.brown[100],
        body: LoginBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  CardContainerSmWidget(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('Recuperar contraseña', style: TextStyle(color: Colors.brown[900], fontSize: 20)),

                          const SizedBox(height: 20),

                          ChangeNotifierProvider(
                            create: (_) => RecuperarContrasenaFormProvider(),
                            child: const _RecuperarContrasenaForm(),
                          ),

                          // Manejo de estado
                          const SizedBox(height: 20),
                        ],
                      )),
                ],
              ),
            ))),
    );



  }
}

class _RecuperarContrasenaForm extends StatefulWidget {
  // Manejo de estado
  const _RecuperarContrasenaForm({Key? key}) : super(key: key);

  @override
  State<_RecuperarContrasenaForm> createState() => _RecuperarContrasenaFormState();
}

class _RecuperarContrasenaFormState extends State<_RecuperarContrasenaForm> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  Future<String> postRecuperarContrasena(String rfc, String celular) async {
    // Mapear la solicitud
    final Map<String, dynamic> authData = {'rfc': rfc, 'celular': celular};
    final url = Uri.http(UriConstants.root, UriConstants.postRecuperarContrasena);

    try {
      final postResponse = await http.post(url, body: json.encode(authData), headers: {"Content-Type": "application/json", "Accept": "application/json"});
      final Map<String, dynamic> data = json.decode(postResponse.body);

      if (postResponse.statusCode.toString() == '200') {
        // Verificar que tenga datos de respuesta del backend
        if (data.containsKey('contrasena')) {
          //debugPrint('data[contrasena]: ${data['contrasena']}');
          setState(() {});

          return data['contrasena'] ?? '';
        } else {
          return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
        }
      } else {
        return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
      }
    } catch (e) {
      //debugPrint('URI: $e');
      return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
    }

    //return 'OK';
  }

  @override
  Widget build(BuildContext context) {
    final theform = Provider.of<RecuperarContrasenaFormProvider>(context);
    MenssagesUI menssagesUI = MenssagesUI();

    return Form(
        key: theform.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'RFC', hintText: 'XXXX999999XX9', prefixIcon: Icons.person_rounded),
              onChanged: (value) => theform.rfc = value, // Ligar aloginform
              validator: (value) {
                String pattern = RegularExpressions.erfRfc;
                RegExp regExp = RegExp(pattern);

                if (value != null && value != '') {
                  return regExp.hasMatch(value) ? null : 'Formato de RFC incorrecto';
                } else {
                  return 'Formato de RFC incorrecto';
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: "No. Celular", hintText: "9999999999", prefixIcon: Icons.phone),
              onChanged: (value) => theform.numeroCelular = value, // Ligar a loginform
              validator: (value) {
                // Validar número de celular a 10 caracteres
                if (value != null && value.length == 10) return null;
                return 'El número de celular debe ser de 10 números';
              },
            ),
            const SizedBox(height: 20),

            // Boton Recuperar la contraseña
            ElevatedButton.icon(
              icon: const Icon(Icons.thumb_up),
              label: const SizedBox(width: double.infinity, child: Center(child: Text('Solicitar...'))),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () async {
                FocusScope.of(context).unfocus(); // Quitar el teclado
                try {
                  if (!theform.isValidForm()) {
                    Platform.isIOS ? menssagesUI.displayDialogIos(context, "Recuperación de contraseña", "Por favor verifique su RFC y Número de Celular") : menssagesUI.displayDialogAndroid(context, "Login", "Por favor verifique su nombre de usuario y contrasña");
                    return;
                  } else {
                    Future<String> respuesta = postRecuperarContrasena(theform.rfc, theform.numeroCelular);

                    respuesta.then((String respuesta) async {
                      Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", respuesta) : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
                      return;
                      // if (respuesta.substring(0, 3) != 'RFC') {
                      //   theform.rfc = '';
                      //   theform.numeroCelular = '';
                      //   setState(() {});

                      //   return;
                      // }
                    });
                  }
                } catch (e) {
                  Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", e.toString()) : menssagesUI.displayDialogAndroid(context, "fabes", e.toString());
                }
              },
            ),
            const SizedBox(height: 15),
            const Text('ATENCIÓN: Si tus datos son correctos, se te mostrará la contraseña en un mensaje.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(246, 175, 90, 21))),

            // Boton Cancelar o regresar
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.chevron_left_outlined),
              label: const SizedBox(width: double.infinity, child: Center(child: Text('Regresar'))),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () async {
                FocusScope.of(context).unfocus(); // Quitar el teclado
                theform.rfc = '';
                theform.numeroCelular = '';
                setState(() {});
                Navigator.popAndPushNamed(context, 'login');
              },
            ),
          ],
        ));
  }
}
