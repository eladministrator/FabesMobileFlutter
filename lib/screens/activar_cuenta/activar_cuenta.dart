import 'package:fabes/arguments/activacion_sms.dart';
import 'package:fabes/theme/app_theme.dart';
import 'package:fabes/theme/bearer_theme.dart';
import 'package:fabes/utils/bearer_utils.dart';
//import 'package:fabes/theme/app';

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

class ActivarCuentaScreen extends StatefulWidget {
  const ActivarCuentaScreen({Key? key}) : super(key: key);

  @override
  State<ActivarCuentaScreen> createState() => _ActivarCuentaScreenState();
}

class _ActivarCuentaScreenState extends State<ActivarCuentaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text('Activación de Cuenta',
                      style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                  const SizedBox(height: 20),

                  // Manejo de estado
                  ChangeNotifierProvider(
                    create: (_) => ActivacionCuentaFormProvider(),
                    child: const _RegistroSmsForm(),
                  ),

                  const SizedBox(height: 10),
                ],
              )),
            ],
          ),
        )));
  }
}

class _RegistroSmsForm extends StatefulWidget {
  // Manejo de estado
  const _RegistroSmsForm({Key? key}) : super(key: key);

  @override
  State<_RegistroSmsForm> createState() => _RegistroSmsFormState();
}

class _RegistroSmsFormState extends State<_RegistroSmsForm> {
  MenssagesUI menssagesUI = MenssagesUI();

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  Future<String> validarCodigosSms(String codigoRecibido) async {
    const storage = FlutterSecureStorage();

    String? codigoDevuelto = await storage.read(key: 'codigo');

    //debugPrint('Codigos: $codigoDevuelto $codigoRecibido');

    if (codigoDevuelto == codigoRecibido) {
      return 'OK';
    } else {
      return 'El código ingresado no coincide.\nFavor de verificar el código que se envió por SMS. ';
    }
  }

  // Solicitud de SMS
  Future<String> registrarSms() async {
    const storage = FlutterSecureStorage();

    String? id = await storage.read(key: 'id');
    String? celular = await storage.read(key: 'celular');

    // Mapear la solicitud
    final Map<String, dynamic> registroData = {'id': id, 'celular': celular};

    //debugPrint('Id y Celular: $registroData');

    final url = Uri.http(UriConstants.root, UriConstants.postTwilio);
    //debugPrint('URI: $url');
    //debugPrint('Registro data: $registroData');

    final postResponse = await http.post(url,
        body: json.encode(registroData),
        headers: {"Content-Type": "application/json", "Accept": "application/json"});

    //debugPrint('Body response: ${postResponse.body}');
    //debugPrint('Estatus code: ${postResponse.statusCode}');

    // Respuesta satisfactoria de la API
    if (postResponse.statusCode == 200) {
      // Mapear la respuesta
      final Map<String, dynamic> response = json.decode(postResponse.body);
      //debugPrint('RegistrarSms response: $response');
      //debugPrint('RegistrarSms response: ${response['codigo']}');

      // Verificar que se tenga un codigo de regreso
      if (response.containsKey('codigo')) {
        if (response['codigo'] == 0) {
          return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: C200';
        } else {
          await storage.write(key: 'codigo', value: response['codigo'].toString());
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
    //!: El provider debe ser igual al que se instancia en el primer widget "ChangeNotifierProvider("
    final form = Provider.of<ActivacionCuentaFormProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ActivacionCuentaSmsArgs;

    return Form(
        key: form.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(children: [
            Text('Paso 1.- Comprobación de datos',
                style: TextStyle(color: Colors.brown[900], fontSize: 17)),
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              // obscureText: true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(
                  labelText: "Ingrese su RFC",
                  hintText: "XXXX000000XX0",
                  prefixIcon: Icons.perm_identity),
              onChanged: (value) => form.rfc = value, // Ligar a loginform
              validator: (value) {
                String pattern =
                    r'^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Formato de RFC incorrecto,\nSolo se admiten números y letras mayúsculas';

                //if (value != null && value.length == 13) return null;
                //return 'El rfc es incorrecto';
              },
            ),
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              //obscureText: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(
                  labelText: "Número de teléfono",
                  hintText: "XXXX000000XX0",
                  prefixIcon: Icons.phone),
              onChanged: (value) => form.telefono = value, // Ligar a loginform
              validator: (value) {
                String pattern = r'^[0-9]{10}$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Número de teléfono incorrecto';
                //if (value != null && value.length == 10) return null;
                //return 'El número de teléfono es incorrecto';
              },
            ),
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              //obscureText: true,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(
                  labelText: "Correo", hintText: "correo@dominio.com", prefixIcon: Icons.mail),
              onChanged: (value) => form.correo = value,
              validator: (value) {
                String pattern = RegularExpressions.erfCorreo;
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : GlobalTextsApp.tagCorreoIncorrecto;
                //if (value != null && value.length >= 4) return null;
                //return 'El correo electronico es incorrecto';
              },
            ),
            const SizedBox(height: 20),
            // Boton Cancelar Activación
            ElevatedButton.icon(
              icon: const Icon(Icons.done_all),
              label: const SizedBox(width: double.infinity, child: Center(child: Text('Activar'))),
              style: ElevatedButton.styleFrom(
                  primary: AppTheme.btnAceptar,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                if (form.rfc == args.rfc &&
                    form.telefono == args.celular &&
                    form.correo == args.correo) {
                  Navigator.pushNamed(context, 'activar_sms',
                      arguments: ActivacionSmsArgs(args.celular, args.correo, args.rfc));
                } else {
                  Platform.isIOS
                      ? menssagesUI.displayDialogIos(context, "fabes",
                          "Los datos ingresados no coinciden con su registro. Favor de pasar a oficinas.")
                      : menssagesUI.displayDialogAndroid(context, "fabes",
                          "Los datos ingresados no coinciden con su registro. Favor de pasar a oficinas.");
                }
              },

              //   //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const SizedBox(
                  width: double.infinity, child: Center(child: Text('Cancelar activación'))),
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 253, 0, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () async {
                Navigator.pushNamed(context, 'login');
              },
              //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
            ),
            const SizedBox(height: 10),
          ]),
        ));
  }
}
