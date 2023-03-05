import 'package:fabes/providers/login_http_service.dart';
import 'package:fabes/screens/activar_cuenta/activar_cuenta.dart';
import 'package:fabes/screens/pre_registro/pre_registro_screen.dart';
import 'package:fabes/screens/screens.dart';
import 'package:fabes/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegurar que ya exista el contexto antes de continuar
  await PushNotificationsService.initializeApp();
  runApp(const AppStates());
}

// Manejador de estados por provider que se ejecutara primero
// en lugar de MyApp()
class AppStates extends StatelessWidget {
  const AppStates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => LoginHttpService(),
        lazy: false,
      )
    ], child: const MyApp());
  }
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Seccion para los keys de los navegator para los snacks
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  //--

  @override
  void initState() {
    super.initState();

    // Subscripcion para los mensajes internos de la app enviados por firebase
    PushNotificationsService.messageStream.listen((internalValue) {

      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        content: Card(
          margin: const EdgeInsets.all(0),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color.fromRGBO(
                  220, 29, 16, 1.0), width: 1)),
          child: ListTile(
            title: const Text('FABES MOBILE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 102, 0, 1))),
            subtitle: Text(internalValue,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            leading:
                const Icon(Icons.message_rounded, color: Color.fromRGBO(255, 102, 0, 1), size: 40),
            contentPadding: const EdgeInsets.all(12),
            onTap: () async {},
          ),
        ),
        duration: const Duration(seconds: 60),
        backgroundColor: const Color.fromRGBO(255, 102, 0, 1),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 70),
        padding: const EdgeInsets.all(2),
        // action: SnackBarAction(
        //   //label: 'Aceptar',
        //   onPressed: () {},
        //   textColor: Colors.white,
        //   disabledTextColor: Colors.red,
        // ),
      );
      messengerKey.currentState!.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fabes',
        initialRoute: 'login',
        navigatorKey: navigatorKey, // Este es necesario para mostrar otra pantalla de navegacion
        scaffoldMessengerKey: messengerKey, // Este es necesario para mostrar snacks
        routes: {
          'login': (context) => const LoginScreen(),
          'rfc': (context) => const RfcScreen(),
          'registro': (context) => const RegistroScreen(),
          'sms': (context) => const RegistroSmsScreen(),
          'gracias': (context) => const RegistroGraciasScreen(),
          'inicio': (context) => const InicioScreen(),
          'ahorros_detalle': (context) => const AhorrosDetalleScreen(),
          'prestamos': (context) => const PrestamosxScreen(),
          'prestamos_detalle': (context) => const PrestamosDetalleScreen(),
          'recuperar_contrasena': (context) => const RecuperarContrasenaScreen(),
          'mensajes': (context) => const MensajesScreen(),
          'preregistro': (_) => const PreregistroScreen(),
          'activar': (_) => const ActivarCuentaScreen(),
          'activar_sms': (_) => const ActivarCuentaSmsScreen()
        },
        theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.brown[50]));
  }
}
