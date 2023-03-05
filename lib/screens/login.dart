// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'package:fabes/theme/bearer_theme.dart';
import 'package:fabes/ui/messages_ui_activacion.dart';
import 'package:fabes/ui/update_app_ui.dart';
import 'package:fabes/utils/bearer_utils.dart' show RegularExpressions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_ios/local_auth_ios.dart';
// Importaciones locales del proyecto
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/ui/bearer_ui.dart';

late bool xcanCheckBiometrics;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Estados para la identificacion de soporte para los datos
// biometricos
enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth =
      LocalAuthentication(); // instanciar paquete de autenticacion
  // Enum para conocer los estados del soporte de la autenticacion
  _SupportState _supportState = _SupportState.unknown;
  bool primerLogin = false; // Indica si el usuario ya inicio sesión una vez
  bool canCheckBiometrics =
      false; // Indica si se pueden checar las instancias biometricas
  List<BiometricType>? availableBiometrics; // Listado de instancias disponibles
  bool setBiometrics =
      false; // Indica si se cuenta con acceso biometrico registrado
  bool _isAuthenticating = false;
  String? nombre;
  String? rfc;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    checkBiometrics();
    getAvailableBiometrics();
    fnPrimerLogin();
  }

  // Validar que el usuario tenga la autenticacion biometrica configurada
  Future<void> checkBiometrics() async {

    late String? login;
    // ignore: prefer_const_constructors
    final storage = FlutterSecureStorage();

    try {
      xcanCheckBiometrics = await auth.canCheckBiometrics;
      login = await storage.read(key: 'primerLogin');

      if (login == 'si') {
        primerLogin = true;
      } else {
        primerLogin = false;
      }
    } on PlatformException catch (e) {
      ////debugPrint(e.toString());
      xcanCheckBiometrics = false;
      primerLogin = false;
      await storage.write(key: 'primerLogin', value: 'no');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      canCheckBiometrics = xcanCheckBiometrics;
    });
  }

  // Validar metodos de autenticacion biometrica disponible
  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        setBiometrics = true;
      } else {
        setBiometrics = false;
      }
    } on PlatformException catch (e) {
      ////debugPrint(e.toString());
      availableBiometrics = <BiometricType>[];
    }
    if (!mounted) {
      return;
    }

    setState(() {
      availableBiometrics = availableBiometrics;
    });
  }

  // Solicitar la autenticacion biometrica
  Future<void> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: GlobalTextsApp.tagUsarBiometrics,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: GlobalTextsApp.tagAutenticacion,
            cancelButton: 'No gracias',
          ),
          IOSAuthMessages(
            cancelButton: 'No gracias',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      //debugPrint(e.toString());
      setState(() {
        _isAuthenticating = false;
      });
      return;
    } catch (e) {
      //debugPrint('Generic Exception: ${e.toString()}');
    }
    if (!mounted) {
      return;
    }

    // ignore: unused_local_variable
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {});

    _isAuthenticating = authenticated;
  }

  // Manejo de variable de primer login
  Future<void> fnPrimerLogin() async {
    const storage = FlutterSecureStorage();

    String? login;

      login = await storage.read(key: 'primerLogin');


    if (login == '0') {
      primerLogin = true;
    } else {
      primerLogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    MenssagesUI menssagesUI = MenssagesUI();
    MenssagesEnd menssagesEnd = MenssagesEnd();

    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: LoginBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainerSmWidget(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(GlobalTextsApp.tagIngreso,
                      style: TextStyle(color: Colors.brown[900], fontSize: 20)),

                  const SizedBox(height: 10),

                 /* SizedBox(
                    height: 60,
                    child: Text(
                        'VARIABLES--> PrimerLogin: ${primerLogin.toString()}, nombre: $nombre rfc: $rfc _supportState $_supportState'),
                  ),*/

                  if (primerLogin)
                    Column(
                      children: [
                        Center(
                          widthFactor: 1.5,
                          child: Text(
                            nombre == null ? '' : nombre!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.brown),
                          ),
                        ),
                        Center(
                            child: Text(
                          rfc == null ? '' : rfc!,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              color: Colors.brown),
                        ))
                      ],
                    ),

                  if (!primerLogin || _supportState == _SupportState.unsupported || !setBiometrics)
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),

                  // Manejo de estado
                  const SizedBox(height: 20),

                  // Gestion de datos biometricos
/*                  if (_supportState == _SupportState.supported &&
                      setBiometrics &&
                      primerLogin)*/

                  if (_supportState == _SupportState.supported &&
                      setBiometrics &&
                      primerLogin)

                    // Boton de ingreso biometrico
                    ElevatedButton.icon(
                      icon: const Icon(Icons.fingerprint),
                      label: const SizedBox(
                          width: double.infinity,
                          child: Center(
                              child: Text(GlobalTextsApp.tagIngresarHuella))),
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 17, 171, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        // ignore: prefer_const_constructors
                        final storage = FlutterSecureStorage();
                        rfc = (await storage.read(key: 'rfc'))!;
                        nombre = (await storage.read(key: 'nombre'))!;

                        String login = (await storage.read(key: 'act'))!;

                        if (login == '0') {
                          setState(() {});

                          if (rfc != null && nombre != null) {
                            await authenticateWithBiometrics();

                            setState(() {
                              fnPrimerLogin();
                            });

                            if (_isAuthenticating) {
                              await storage.write(
                                  key: 'primerLogin', value: 'si');
                              String? tipoMensaje =
                                  await storage.read(key: 'tipoMensaje');
                              String? mensaje =
                                  await storage.read(key: 'mensaje');
                              String? solicitaPrestamo =
                                  await storage.read(key: 'solicitaPrestamo');

                              if (mensaje == '') {
                                Navigator.pushReplacementNamed(
                                    context, 'inicio',
                                    arguments: InicioArgs(rfc ?? '',
                                        nombre ?? '', solicitaPrestamo ?? ''));
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, 'mensajes',
                                    arguments: MensajesArgs(
                                        rfc!, nombre!, tipoMensaje!, mensaje!));
                              }
                              //await Navigator.pushReplacementNamed(context, 'inicio', arguments: InicioArgs(rfc!, nombre!));
                            }
                          } else {
                            await storage.write(
                                key: 'primerLogin', value: 'no');
                            Platform.isIOS
                                ? menssagesUI.displayDialogIos(context, "Login",
                                    GlobalTextsApp.tagVerificarCredenciales)
                                : menssagesUI.displayDialogAndroid(
                                    context,
                                    "Login",
                                    "Por favor verifique su nombre de usuario y contrasña");
                          }
                        } else if (login == '1') {
                          Platform.isIOS
                              ? menssagesEnd.displayDialogIos(context, "Login",
                                  GlobalTextsApp.tagNuevaVersionIOS)
                              : menssagesEnd.displayDialogAndroid(
                                  context,
                                  "Login",
                                  GlobalTextsApp.tagNuevaVersionAndroid);
                        } else if (login == '2') {
                          Platform.isIOS
                              ? menssagesEnd.displayDialogIos(context, "Login",
                                  GlobalTextsApp.tagMantenimiento)
                              : menssagesEnd.displayDialogAndroid(context,
                                  "Login", GlobalTextsApp.tagMantenimiento);
                        }
                      },
                      //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
                    ),

                  const SizedBox(height: 5),
                  if (_supportState == _SupportState.supported &&
                      setBiometrics &&
                      primerLogin)
                    TextButton(
                        style: const ButtonStyle(
                          overlayColor: null,
                        ),
                        onPressed: () async {
                          const storage = FlutterSecureStorage();
                          primerLogin = false;
                          _isAuthenticating = false;
                          nombre = '';
                          rfc = '';

                          await storage.delete(key: 'token');
                          await storage.delete(key: 'sesion');
                          await storage.write(key: 'primerLogin', value: 'no');
                          await storage.write(key: 'nombre', value: '');
                          await storage.write(key: 'rfc', value: '');

                          setState(() {});
                        },
                        child: const Text(GlobalTextsApp.tagCambiarCuenta,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 163, 63, 26)))),
                  const SizedBox(height: 30),

                  //if (_supportState == _SupportState.unknown) const CircularProgressIndicator() else if (_supportState == _SupportState.supported) const Text(TextsApp.tagSiBiometrics, style: TextStyle(fontSize: 12)) else const Text(TextsApp.tagNoBiometrics, style: TextStyle(fontSize: 12)),

                  //if (setBiometrics) const Text(TextsApp.tagSetBiometrics, style: TextStyle(fontSize: 12)) else const Text(TextsApp.tagNoSetBiometrics, style: TextStyle(fontSize: 12))
                ],
              )),
            ],
          ),
        )));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  UpdateAppUI updateAppUI = UpdateAppUI();

  @override
  void initState() {
    super.initState();
  }

  Future<String> postValidarVersion() async {
    final url = Uri.http(UriConstants.root, UriConstants.postVersiones);
    final Map<String, dynamic> envio = {'activa': 1};
    const storage = FlutterSecureStorage();

    const miVersion = '1.03';
    String act = '';
    //try {
      final response = await http.post(url, body: json.encode(envio), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      });
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode.toString() == '200') {
        final versionServidor = data['data']['version'];
        final estatus = data['data']['activa'];

        // Indica que no se debe de actualizar
        if (miVersion == versionServidor && estatus == 1) {
          act = '0';
        }

        // Indica que no se puede ingresar
        if (estatus == 2) {
          act = '2';
        }

        // Indica que hay un cambio de version y se debe de actualizar
        if (miVersion != versionServidor && estatus == 1) {
          act = '1';
        }
        await storage.write(key: 'act', value: act);

        return act;
      } else {
        act = '2';
        await storage.write(key: 'act', value: act);
        return act;
      }
   /* } catch (e) {
      act = '999';
      return act;
    }*/
  }

  Future<String> postValidarCredenciales(String correo, String password) async {
    // ignore: prefer_const_constructors
    final storage = FlutterSecureStorage();

    String? token = await storage.read(key: 'tokenFirebase');

    // Mapear la solicitud
    final Map<String, dynamic> authData = {
      'correo': correo,
      'password': password,
      'tokenFirebase': token
    };
    final url = Uri.http(UriConstants.root, UriConstants.postAuthenticaction);
    final postResponse = await http.post(url,
        body: json.encode(authData),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });

    // Mapear la respuesta
    final Map<String, dynamic> data = json.decode(postResponse.body);

    if (postResponse.statusCode.toString() == '200') {
      // Verificar que tenga datos de respuesta del backend
      if (data.containsKey('respuesta') && data.containsKey('idUsuario') && data['idUsuario'] != '0') {
        ////debugPrint('Response body: $data');
        ////debugPrint('Decode: ${data['respuesta']}');

        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'nombre', value: data['nombre']);
        await storage.write(key: 'sesion', value: data['sesion']);
        await storage.write(key: 'fkskempleo', value: data['fkskempleo'].toString());
        await storage.write(key: 'correo', value: correo);
        await storage.write(key: 'rfc', value: data['rfc']);
        await storage.write(key: 'totalAhorrado', value: data['totalAhorrado'].toString());
        await storage.write(key: 'primerLogin', value: 'si');
        await storage.write(key: 'tipoMensaje', value: '1');
        await storage.write(key: 'activo', value: data['activo'].toString());
        await storage.write(key: 'mensaje', value: data['mensaje']);
        await storage.write(key: 'celular', value: data['celular']);
        await storage.write(key: 'correo', value: correo);
        await storage.write(key: 'solPrestamo', value: data['solPrestamo'].toString());
        //await storage.write(key: 'solicitaPrestamo', value: '1');



        ////debugPrint(data['mensaje']);

        setState(() {});
        return data['respuesta'] ?? '';
      } else {
        //return GlobalTextsApp.tagMantenimiento;
        return data['respuesta'].toString();
      }
    } else {
      return GlobalTextsApp.tagMantenimiento;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    MenssagesUI menssagesUI = MenssagesUI();
    MenssagesActivacionUI mensageActivacion = MenssagesActivacionUI();

    return Form(
        key: loginForm.formkey, // Manejo de estadofrecu
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: FutureBuilder<String>(
            future: postValidarVersion(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (snapshot.data == '2') {
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(GlobalTextsApp.tagMantenimiento),
                    ),
                  ];
                } else if (snapshot.data == '1') {
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(GlobalTextsApp.tagNuevaVersionAndroid),
                    ),
                  ];
                } else if (snapshot.data == '999') {
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Al parecer no cuentas con internet.'),
                    ),
                  ];
                } else {
                  children = <Widget>[
                    TextFormField(
                      cursorColor: const Color.fromRGBO(255, 102, 0, 1),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.brown),
                      decoration: InputDecorationsUI.loginInputDecoration(
                          labelText: 'Correo electrónico',
                          hintText: 'correo@gmail.com',
                          prefixIcon: Icons.mail_lock),
                      onChanged: (value) =>
                          loginForm.email = value, // Ligar aloginform
                      validator: (value) {
                        String pattern = RegularExpressions.erfCorreo;
                        RegExp regExp = RegExp(pattern);

                        return regExp.hasMatch(value ?? '')
                            ? null
                            : GlobalTextsApp.tagCorreoIncorrecto;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: const Color.fromRGBO(255, 102, 0, 1),
                      autocorrect: false,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.brown),
                      decoration: InputDecorationsUI.loginInputDecoration(
                          labelText: "Contraseña",
                          hintText: "********",
                          prefixIcon: Icons.security_rounded),
                      onChanged: (value) =>
                          loginForm.password = value, // Ligar a loginform
                      validator: (value) {
                        if (value != null && value.length >= 4) return null;

                        return GlobalTextsApp.tagContrasenaIncorrecto;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Boton de ingresar
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(255, 102, 0, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        // Con esta instruccion en base al getter se bloquea al boton
                        onPressed: loginForm.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context)
                                    .unfocus(); // Quitar el teclado



                                //try {
                                  const storage = FlutterSecureStorage();
                                  //INFO: Formulario incorrecto
                                  if (!loginForm.isValidForm()) {
                                    Platform.isIOS
                                        ? menssagesUI.displayDialogIos(
                                            context,
                                            "Login",
                                            GlobalTextsApp.tagVerificarCredenciales)
                                        : menssagesUI.displayDialogAndroid(
                                            context,
                                            "Login",
                                            GlobalTextsApp.tagVerificarCredenciales);
                                    return;
                                  } else {
                                    //INFO: Formulario correcto, validar credenciales
                                    Future<String> respuesta = postValidarCredenciales(loginForm.email, loginForm.password);

                                    respuesta.then((String respuesta) async {

                                      if(respuesta.toUpperCase() == 'OK')
                                        {



                                          String? rfc = await storage.read(key: 'rfc');
                                          String? nombre = await storage.read(key: 'nombre');
                                          String? celular = await storage.read(key: 'celular');


                                          String? correo = "";
                                          correo = await storage.read(key: 'correo');

                                          String? solicitaPrestamo = "";
                                          solicitaPrestamo = await storage.read(key: 'solPrestamo');

                                          String? activo = "";
                                          activo = await storage.read(key: 'activo');


                                          //String? tipoMensaje = await storage.read(  key: 'tipoMensaje');
                                          //String? mensaje = await storage.read(key: 'mensaje');

                                          correo ??= "nulo";
                                          activo ??= "nulo";
                                          solicitaPrestamo ??= "nulo";

                                          /*if( Platform.isIOS){
                                            menssagesUI.displayDialogIos(context,
                                                "Entro ios", '$correo, $solicitaPrestamo, $activo');
                                          }else if( Platform.isAndroid){
                                            menssagesUI.displayDialogAndroid( context,
                                                "entro android", '$correo , $solicitaPrestamo, $activo');
                                          }else{
                                            menssagesUI.displayDialogAndroid(context,
                                                'Entro esta','$correo , $solicitaPrestamo, $activo');
                                          }
                                          return;*/

                                          //INFO: Cuenta activa "1"




                                          if (activo == "1") {
                                            Navigator.pushReplacementNamed(
                                                context, 'inicio',
                                                arguments: InicioArgs(
                                                    rfc ?? '',
                                                    nombre ?? '',
                                                    solicitaPrestamo ?? ''));
                                          } else {
                                            //INFO: Cuenta inactiva "0"
                                            await storage.write(key: 'primerLogin', value: 'no');

                                            if(Platform.isIOS){
                                              mensageActivacion.displayDialogIos(
                                                  context,
                                                  rfc ?? '',
                                                  correo ?? '',
                                                  celular ?? '',
                                                  nombre ?? '');
                                            }else if( Platform.isAndroid){
                                              mensageActivacion.displayDialogAndroid(
                                                  context,
                                                  rfc ?? '',
                                                  correo ?? '',
                                                  celular ?? '',
                                                  nombre ?? '');
                                            }else{
                                              mensageActivacion.displayDialogAndroid(
                                                  context,
                                                  rfc ?? '',
                                                  correo ?? '',
                                                  celular ?? '',
                                                  nombre ?? '');
                                            }

                                            /*Platform.isIOS ? mensageActivacion.displayDialogIos(
                                                context,
                                                rfc ?? '',
                                                correo ?? '',
                                                celular ?? '',
                                                nombre ?? '')
                                                : mensageActivacion
                                                .displayDialogAndroid(
                                                context,
                                                rfc ?? '',
                                                correo ?? '',
                                                celular ?? '',
                                                nombre ?? '');*/
                                          }
                                        }else{
                                        Platform.isIOS
                                            ? menssagesUI.displayDialogIos(
                                            context, "fabes", respuesta)
                                            : menssagesUI.displayDialogAndroid(
                                            context, "fabes", respuesta);
                                      }

                                      return;

                                    });
                                  }
                               /* } catch (e) {
                                  Platform.isIOS
                                      ? menssagesUI.displayDialogIos(
                                          context, "fabes", e.toString())
                                      : menssagesUI.displayDialogAndroid(
                                          context, "fabes", e.toString());
                                }*/
                              },
                        child: SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Text(loginForm.isLoading
                                    ? 'validando usuario ...'
                                    : 'Ingresar')))),

                    // const Text('ATENCIÓN: Con gusto le informamos que hay una nueva actualización. Por favor cierre la aplicación y posteriormente entre a la tienda para actaulizar y poder seguirla utilizando.',
                    //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(246, 175, 90, 21))),
                    const SizedBox(height: 5),

                    TextButton(
                        style: const ButtonStyle(
                          overlayColor: null,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'rfc');
                        },
                        child: const Text(GlobalTextsApp.tagRegistrarme,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.brown))),
                    const SizedBox(height: 5),

                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, 'recuperar_contrasena',
                              arguments: RecuperarContrasenaArgs('', ''));
                        },
                        child: const Text(
                          'Recuperar contraseña',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(height: 25),
                    const Text(
              'Versión 2.1.4',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.green),
              ),
                  ];
                }
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                // Mientras carga
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Obteniendo datos...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            }));
  }
}
