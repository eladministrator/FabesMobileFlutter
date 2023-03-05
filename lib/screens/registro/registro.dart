import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Importaciones locales del proyecto
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/ui/bearer_ui.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:  Scaffold(
    backgroundColor: Colors.brown[100],
        body: LoginBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 250),
                  CardContainer(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text('Paso 2.- Registro', style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                          const SizedBox(height: 20),

                          // Manejo de estado
                          ChangeNotifierProvider(
                            create: (_) => RegistroFormProvider(),
                            child: const _RegistroForm(),
                          ),

                          const SizedBox(height: 10),
                        ],
                      )),
                ],
              ),
            )))
    );




  }
}

class _RegistroForm extends StatefulWidget {
  // Manejo de estado
  const _RegistroForm({Key? key}) : super(key: key);

  @override
  State<_RegistroForm> createState() => _RegistroFormState();
}

class _RegistroFormState extends State<_RegistroForm> {
  MenssagesUI menssagesUI = MenssagesUI();

  Future<String> registrar(String correo, String celular, String password) async {
    const storage = FlutterSecureStorage();

    String? rfc = await storage.read(key: 'rfc');

    // Mapear la solicitud
    final Map<String, dynamic> registroData = {'email': correo, 'celular': celular, 'rfc': rfc, 'password': password};

    final url = Uri.http(UriConstants.root, UriConstants.postRegistro);
    //debugPrint('URI: $url');
    //debugPrint('Registro data: $registroData');

    final postResponse = await http.post(url, body: json.encode(registroData), headers: {"Content-Type": "application/json", "Accept": "application/json"});

    //debugPrint('Body response: ${postResponse.body}');
    //debugPrint('Estatus code: ${postResponse.statusCode}');

    // Respuesta satisfactoria de la API
    if (postResponse.statusCode == 200) {
      // Mapear la respuesta
      final Map<String, dynamic> data = json.decode(postResponse.body);
      //debugPrint('Data response: $data');

      //Validar primero el codenumber

      // Verificar que tenga datos de respuesta del backend
      if (data['data'].containsKey('respuesta')) {
        await storage.write(key: 'rfc', value: rfc);
        await storage.write(key: 'id', value: data['data']['id'].toString());
        await storage.write(key: 'celular', value: data['data']['celular'].toString());

        return data['data']['respuesta'] ?? '';
      } else {
        return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
      }
    } else {
      return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<RegistroFormProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as RegistroArgs;
    // const storage = FlutterSecureStorage();
    // String? rfc = await storage.read(key: 'rfc');

    return Form(
        key: loginForm.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Text('RFC: ${args.rfc}'),
            // Correo
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.none,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'Correo', hintText: 'correo@dominio.com', prefixIcon: Icons.mail),
              onChanged: (value) => loginForm.correo = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Formato de correo incorrecto';
              },
            ),
            const SizedBox(height: 10),
            // Celular
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'Teléfono', hintText: '9619999999', prefixIcon: Icons.call_sharp),
              onChanged: (value) => loginForm.telefono = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^[0-9]{10}$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Número de teléfono incorrecto';
              },
            ),
            const SizedBox(height: 10),
            // Contrasena
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'Contraseña', hintText: '********', prefixIcon: Icons.password),
              onChanged: (value) => loginForm.contrasena = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Mínimo ocho caracteres, al menos una letra y un número';
              },
            ),
            const SizedBox(height: 10),
            // Confirmar Contrasena
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'Confirmar Contraseña', hintText: '********', prefixIcon: Icons.password),
              onChanged: (value) => loginForm.contrasenaConfirmada = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Mínimo ocho caracteres, al menos una letra y un número';
              },
            ),

            const SizedBox(height: 10),
            // Boton de ingresar
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                // Con esta instruccion en base al getter se bloquea al boton
                onPressed: loginForm.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // Quitar el teclado

                        if (!loginForm.isValidForm()) {
                          Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", "Por favor verifique sus datos") : menssagesUI.displayDialogAndroid(context, "fabes", "Por favor verifique sus datos");
                          return;
                        } else {
                          if (loginForm.contrasena != loginForm.contrasenaConfirmada) {
                            Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", "Las contraseñas no coinciden, favor de verificar") : menssagesUI.displayDialogAndroid(context, "fabes", "Las contraseñas no coinciden, favor de verificar");
                            return;
                          }

                          Future<String> respuesta = registrar(loginForm.correo, loginForm.telefono, loginForm.contrasena);

                          respuesta.then((String respuesta) async {
                            if (respuesta.toUpperCase() != 'OK') {
                              Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", respuesta) : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
                              return;
                            } else {
                              //Navigator.pushReplacementNamed(context, 'sms',arguments: RegistroArgs(loginForm.rfc));
                              Navigator.pushNamed(context, "sms", arguments: RegistroSmsArgs(loginForm.telefono));
                            }
                          });
                        }

                        //loginForm.isLoading = true;
                        //loginForm.isLoading = false;

                        // ignore: use_build_context_synchronously
                        // Navigator.pushReplacementNamed(context, 'home');
                      },
                child: SizedBox(width: double.infinity, child: Center(child: Text(loginForm.isLoading ? 'Validando usuario ...' : 'Validar')))),
          ],
        ));
  }
}
