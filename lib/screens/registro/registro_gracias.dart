import 'package:fabes/ui/bearer_ui.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Importaciones locales del proyecto
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/services/uri_constants.dart';

class RegistroGraciasScreen extends StatefulWidget {
  const RegistroGraciasScreen({Key? key}) : super(key: key);

  @override
  State<RegistroGraciasScreen> createState() => _RegistroGraciasScreenState();
}

class _RegistroGraciasScreenState extends State<RegistroGraciasScreen> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
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
                          Text('Paso 4.- ¡Felicidades!', style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                          const SizedBox(height: 20),

                          // Manejo de estado
                          ChangeNotifierProvider(
                            create: (_) => RegistroFormProvider(),
                            child: const _RegistroGraciasForm(),
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

class _RegistroGraciasForm extends StatefulWidget {
  // Manejo de estado
  const _RegistroGraciasForm({Key? key}) : super(key: key);

  @override
  State<_RegistroGraciasForm> createState() => _RegistroGraciasFormState();
}

class _RegistroGraciasFormState extends State<_RegistroGraciasForm> {
  Future<String> activarUsuario() async {
    //UriConstants uriConstants = UriConstants();
    const storage = FlutterSecureStorage();

    String? ids = await storage.read(key: 'id');

    var id = int.parse(ids!);

    // Mapear la solicitud
    final Map<String, dynamic> registroData = {'id': id};

    //debugPrint('registroData Map: $registroData');

    final url = Uri.http(UriConstants.root, UriConstants.postActivacion);
    //debugPrint('URI: $url');

    final postResponse = await http.post(url, body: json.encode(registroData), headers: {"Content-Type": "application/json", "Accept": "application/json"});

    //debugPrint('Body response: ${postResponse.body}');
    //debugPrint('Estatus code: ${postResponse.statusCode}');

    // Respuesta satisfactoria de la API
    if (postResponse.statusCode == 200) {
      // Mapear la respuesta
      final Map<String, dynamic> response = json.decode(postResponse.body);
      //debugPrint('RegistrarSms response: $response');
      //debugPrint('RegistrarSms response: ${response['codigo']}');

      // Verificar que se tenga un codigo de regreso
      if (response['data'].containsKey('respuesta')) {
        //debugPrint('Si tiene respuesta');
        //debugPrint('La respuesta: ${response['data']['respuesta'].toString().toUpperCase()}');
        if (response['data']['respuesta'].toString().toUpperCase() != 'OK') {
          return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: NOK200';
        } else {
          return 'OK';
        }
      } else {
        return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: B200';
      }
    } else {
      return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: N200';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<RegistroFormProvider>(context);
    MenssagesUI menssagesUI = MenssagesUI();
    //final args =  ModalRoute.of(context)!.settings.arguments as RegistroArgs;
    return Form(
        key: loginForm.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text('Felicidades, el registro se llevó a cabo  de forma correcta, puede ingresar en la pantalla de inicio con su correo y contraseña registrados.', style: TextStyle(color: Colors.brown, fontSize: 15)),
            const SizedBox(height: 25),

            // Boton de validar
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                // Con esta instruccion en base al getter se bloquea al boton
                onPressed: loginForm.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // Quitar el teclado

                        Future<String> respuesta = activarUsuario();

                        respuesta.then((String respuesta) async {
                          if (respuesta.toUpperCase() != 'OK') {
                            Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", respuesta) : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
                            return;
                          } else {
                            Navigator.pushNamed(context, "login");
                          }
                        });
                      },
                child: SizedBox(width: double.infinity, child: Center(child: Text(loginForm.isLoading ? 'validando usuario ...' : 'Finalizar')))),

            const SizedBox(height: 10),
          ],
        ));
  }
}
