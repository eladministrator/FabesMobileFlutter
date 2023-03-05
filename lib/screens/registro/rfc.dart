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

class RfcScreen extends StatefulWidget {
  const RfcScreen({Key? key}) : super(key: key);

  @override
  State<RfcScreen> createState() => _RfcScreenState();
}

class _RfcScreenState extends State<RfcScreen> {
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
                          Text('Paso 1.- Validación de RFC', style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                          const SizedBox(height: 30),

                          // Manejo de estado
                          ChangeNotifierProvider(
                            create: (_) => RfcFormProvider(),
                            child: const _RfcForm(),
                          ),

                          const SizedBox(height: 30),
                        ],
                      )),
                ],
              ),
            )))
    );





  }
}

class _RfcForm extends StatefulWidget {
  // Manejo de estado
  const _RfcForm({Key? key}) : super(key: key);

  @override
  State<_RfcForm> createState() => _RfcFormState();
}

class _RfcFormState extends State<_RfcForm> {
  MenssagesUI menssagesUI = MenssagesUI();

  Future<String> postVerificarRFC(String rfc) async {
    const storage = FlutterSecureStorage();

    rfc = rfc.toUpperCase();

    final url = Uri.http(UriConstants.root, '${UriConstants.getValidarRFC}$rfc');
    //debugPrint('URI: $url');

    final postResponse = await http.get(url, headers: {"Accept": "*/*"});

    //debugPrint('Body response: ${postResponse.body}');
    //debugPrint('Estatus code: ${postResponse.statusCode}');

    // Respuesta satisfactoria de la API
    if (postResponse.statusCode == 200) {
      // Mapear la respuesta
      final Map<String, dynamic> data = json.decode(postResponse.body);
      //debugPrint('Data response: $data');

      // Verificar que tenga datos de respuesta del backend
      if (data['data'].containsKey('respuesta')) {
        await storage.write(key: 'rfc', value: rfc);

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
    final loginForm = Provider.of<RfcFormProvider>(context);

    return Form(
        key: loginForm.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(labelText: 'RFC', hintText: 'XXXX999999XX9', prefixIcon: Icons.person),
              onChanged: (value) => loginForm.rfc = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Formato de RFC incorrecto,\nSolo se admiten números y letras mayúsculas';
              },
            ),

            const SizedBox(height: 30),
            // Boton de ingresar
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                // Con esta instruccion en base al getter se bloquea al boton
                onPressed: loginForm.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // Quitar el teclado

                        if (!loginForm.isValidForm()) {
                          Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", "Por favor verifique su RFC") : menssagesUI.displayDialogAndroid(context, "fabes", "Por favor verifique su RFC");
                          return;
                        } else {
                          Future<String> respuesta = postVerificarRFC(
                            loginForm.rfc,
                          );

                          respuesta.then((String respuesta) async {
                            if (respuesta != 'OK') {
                              Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", respuesta) : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
                              return;
                            } else {
                              // Pasar el rfc por parametros
                              Navigator.pushNamed(context, "registro", arguments: RegistroArgs(loginForm.rfc));
                              //Navigator.pushReplacementNamed(context, 'registro');\

                            }
                          });
                        }

                        //loginForm.isLoading = true;
                        //loginForm.isLoading = false;

                        // ignore: use_build_context_synchronously
                        // Navigator.pushReplacementNamed(context, 'home');
                      },
                child: SizedBox(width: double.infinity, child: Center(child: Text(loginForm.isLoading ? 'validando usuario ...' : 'validar')))),

            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.chevron_left_outlined),
              label: const SizedBox(width: double.infinity, child: Center(child: Text('Cancelar'))),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () async {
                FocusScope.of(context).unfocus(); // Quitar el teclado

                Navigator.popAndPushNamed(context, 'login');
              },
            ),

          ],
        ));
  }
}
