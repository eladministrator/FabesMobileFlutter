import 'package:fabes/arguments/activacion_sms.dart';
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

class ActivarCuentaSmsScreen extends StatefulWidget {
  const ActivarCuentaSmsScreen({Key? key}) : super(key: key);

  @override
  State<ActivarCuentaSmsScreen> createState() => _ActivarCuentaSmsScreenState();
}

class _ActivarCuentaSmsScreenState extends State<ActivarCuentaSmsScreen> {
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
                  Text('Paso 3.- Identidad por SMS',
                      style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                  const SizedBox(height: 20),

                  // Manejo de estado
                  ChangeNotifierProvider(
                    create: (_) => CodigoFormProvider(),
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
    setState(() {
      Future<String> respuesta = registrarSms();
      respuesta.then((String respuesta) async {
        if (respuesta.toUpperCase() != 'OK') {
          Platform.isIOS
              ? menssagesUI.displayDialogIos(context, "fabes", respuesta)
              : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
          return;
        } else {
          //Navigator.pushReplacementNamed(context, 'sms',arguments: RegistroArgs(loginForm.rfc));
          //Navigator.pushNamed(context, "sms",arguments: RegistroSmsArgs(loginForm.telefono));
        }
      });
    });
  }

//INFO: Activar cuenta en las tablas de mobile
  Future<String> activarCuenta() async {
    const storage = FlutterSecureStorage();

    String? rfc = await storage.read(key: 'rfc');
    String? celular = await storage.read(key: 'celular');
    String? correo = await storage.read(key: 'correo');

    final Map<String, dynamic> request = {'rfc': rfc, 'celular': celular, 'email': correo};

    final url = Uri.http(UriConstants.root, UriConstants.postActivarCuenta);
    //debugPrint('URI: $url');
    //debugPrint('Registro data: $request');

    final postResponse = await http.post(url,
        body: json.encode(request),
        headers: {"Content-Type": "application/json", "Accept": "application/json"});

    //debugPrint('Body response: ${postResponse.body}');
    //debugPrint('Estatus code: ${postResponse.statusCode}');

    //await storage.delete(key: 'token');
    //await storage.delete(key: 'sesion');
    // await storage.delete(key: 'activo');
    await storage.write(key: 'primerLogin', value: 'no');

    return "OK";

    // Respuesta satisfactoria de la API
    // if (postResponse.statusCode == 200) {
    //   // Mapear la respuesta
    //   final Map<String, dynamic> response = json.decode(postResponse.body);
    //   //debugPrint('RegistrarSms response: $response');
    //   //debugPrint('RegistrarSms response: ${response['codigo']}');

    //   // Verificar que se tenga un codigo de regreso
    //   if (response.containsKey('codigo')) {
    //     if (response['codigo'] == 0) {
    //       return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: C200';
    //     } else {
    //       await storage.write(key: 'codigo', value: response['codigo'].toString());
    //       return 'OK';
    //     }
    //   } else {
    //     return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: B200';
    //   }
    // } else {
    //   return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.\nMensaje: N200';
    // }
  }

  //INFO: Valida que el código recibido por SMS
  Future<String> validarCodigosSms(String codigoRecibido) async {
    const storage = FlutterSecureStorage();

    String? codigoDevuelto = await storage.read(key: 'codigo');

    //debugPrint('Codigos: $codigoDevuelto $codigoRecibido');

    if (codigoDevuelto == codigoRecibido) {
      Future<String> respuesta = activarCuenta();
      respuesta.then((String respuesta) async {
        if (respuesta.toUpperCase() != 'OK') {
          Platform.isIOS
              ? menssagesUI.displayDialogIos(context, "fabes", respuesta)
              : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
          return '';
        } else {
          Platform.isIOS
              ? menssagesUI.displayDialogIos(context, "fabes",
                  'Tu cuenta ha sido activada con éxito, ya puedes ingresar a Fabes Mobile con tu usuario y contraseña.')
              : menssagesUI.displayDialogAndroid(context, "fabes",
                  'Tu cuenta ha sido activada con éxito, ya puedes ingresar a Fabes Mobile con tu usuario y contraseña.');
        }
      });
      return 'OK';
    } else {
      return '';
    }
  }

  //INFO: Entra por defecto para Solicitud de SMS
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
    final loginForm = Provider.of<CodigoFormProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ActivacionSmsArgs;

    return Form(
        key: loginForm.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Center(
                child: Text(
                    'Hola,le hemos enviado un mensaje de texto (SMS) con el código de verificación de 4 caracteres para confirmar su identidad y mantener segura su información. ',
                    style: TextStyle(color: Colors.brown, fontSize: 15))),
            const SizedBox(height: 8),
            Text('Celular: ${args.celular}',
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(
                child: Text(
                    'Le recomendamos estar en un lugar donde tenga una buena señal de celular, ya que de lo contrario no le llegará el mensaje.',
                    style: TextStyle(color: Colors.brown, fontSize: 15))),
            const SizedBox(height: 25),

            // Txt Codigo
            TextFormField(
              cursorColor: const Color.fromRGBO(255, 102, 0, 1),
              autocorrect: false,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.brown),
              decoration: InputDecorationsUI.loginInputDecoration(
                  labelText: 'Código', hintText: '0000', prefixIcon: Icons.security),
              onChanged: (value) => loginForm.codigo = value, // Ligar aloginform
              validator: (value) {
                String pattern = r'^[0-9]{4}$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Formato de código incorrecto';
              },
            ),
            const SizedBox(height: 10),

            // Boton de Solicitar Código
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            //     // Con esta instruccion en base al getter se bloquea al boton
            //     onPressed: loginForm.isLoading
            //         ? null
            //         : () {
            //             FocusScope.of(context).unfocus(); // Quitar el teclado

            //             Future<String> respuesta = registrarSms();

            //             respuesta.then((String respuesta) async {
            //               if (respuesta.toUpperCase() != 'OK') {
            //                 Platform.isIOS ? menssagesUI.displayDialogIos(context, "fabes", respuesta) : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
            //                 return;
            //               } else {
            //                 //Navigator.pushReplacementNamed(context, 'sms',arguments: RegistroArgs(loginForm.rfc));
            //                 //Navigator.pushNamed(context, "sms",arguments: RegistroSmsArgs(loginForm.telefono));
            //               }
            //             });

            //             //Navigator.pushReplacementNamed(context, 'gracias');
            //           },
            //     child: SizedBox(width: double.infinity, child: Center(child: Text(loginForm.isLoading ? 'validando usuario ...' : 'Solicitar mi código')))),
            // const SizedBox(height: 10),
            // Boton Validar codigos
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 118, 88, 68),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                // Con esta instruccion en base al getter se bloquea al boton
                onPressed: loginForm.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // Quitar el teclado

                        if (!loginForm.isValidForm()) {
                          Platform.isIOS
                              ? menssagesUI.displayDialogIos(
                                  context, "fabes", "Por favor ingrese un código de 4 números")
                              : menssagesUI.displayDialogAndroid(
                                  context, "fabes", "Por favor ingrese un código de 4 números");
                          return;
                        }
                        Future<String> respuesta = validarCodigosSms(loginForm.codigo);

                        respuesta.then((String respuesta) async {
                          if (respuesta.toUpperCase() != 'OK') {
                            Platform.isIOS
                                ? menssagesUI.displayDialogIos(context, "fabes", respuesta)
                                : menssagesUI.displayDialogAndroid(context, "fabes", respuesta);
                            return;
                          } else {
                            Navigator.pushNamed(context, "login");
                          }
                        });
                      },
                child: SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Text(loginForm.isLoading ? 'validando usuario ...' : 'Verificar')))),

            const SizedBox(height: 10),
          ],
        ));
  }
}
