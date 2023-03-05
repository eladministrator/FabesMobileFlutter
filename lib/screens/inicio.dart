import 'package:fabes/models/prestamos_card_response.dart';
import 'package:fabes/providers/valida_solicitar_nuevo_prestamo.dart';
import 'package:fabes/providers/verificar_pago_quincenal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Importaciones locales del proyecto
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/ui/bearer_ui.dart';

MenssagesUI menssagesUI = MenssagesUI();
var formatear = NumberFormat('###,###.00', 'en_US');

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  Widget build(BuildContext context) {
    final inicioArgs = ModalRoute.of(context)!.settings.arguments as InicioArgs;
    var formatear = NumberFormat('###,###.00', 'en_US');


    Future<void> eliminarSesion() async {
      const storage = FlutterSecureStorage();

      //await storage.delete(key: 'nombre');
      //await storage.delete(key: 'rfc');
      await storage.delete(key: 'token');
      await storage.delete(key: 'sesion');
      //await storage.delete(key: 'fkskempleo');
      //await storage.delete(key: 'totalAhorrado');
    }

    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: BackgroundWidget(
          topLogo: 60, // ajusta el top del logotipo
          topChild2: 150, // ajusta la altura del label de nombre y rfc
          // child2: Pasa el nombre y rfc al widget del background
          child2: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                //widthFactor: 1,
                child: Text(
                  inicioArgs.nombre,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown),
                  //textAlign: TextAlign.center,
                ),
              ),
              Center(
                  child: Text(
                inicioArgs.rfc,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Colors.brown),
              ))
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 220),
                CardContainerSmWidget(
                    child: Column(
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => RegistroFormProvider(),
                      child: const _InicioForm(),
                    ),

                    ChangeNotifierProvider(
                      create: (context) =>
                          ValidaSolicitarNuevoPrestamoProvider(),
                      child: Consumer<ValidaSolicitarNuevoPrestamoProvider>(
                          builder: (context, provider, child) {
                        if (provider.data == null) {
                          provider.getData(context);
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.orange,
                          ));
                        }
                        //INFO: if (provider.data!.data.respuesta == "1") {
                        if (provider.data!.data.respuesta == "1" &&
                            provider.data!.data.total == 0) {
                          return Card(
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5, top: 5),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 102, 0, 1),
                                      width: 2)),
                              shadowColor: Colors.brown[300],
                              elevation: 8,
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 5, left: 8, right: 5, bottom: 5),
                                title: const Text('Préstamo',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 102, 0, 1))),
                                subtitle: const Text('Solicitar un préstamo',
                                    style: TextStyle(fontSize: 14)),
                                leading: const Icon(Icons.savings_outlined,
                                    color: Color.fromARGB(255, 0, 106, 255),
                                    size: 40),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color.fromRGBO(255, 102, 0, 1),
                                    size: 30),
                                onTap: () async {
                                  Navigator.pushNamed(context, "preregistro",
                                      arguments: MensajesArgs(inicioArgs.rfc,
                                          inicioArgs.nombre, 'dd', 'dd'));
                                },
                              ));
                        } else if (provider.data!.data.respuesta == "1" &&
                            provider.data!.data.total > 1) {
                          return Card(
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5, top: 5),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 102, 0, 1),
                                      width: 2)),
                              shadowColor: Colors.brown[300],
                              elevation: 8,
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 5, left: 8, right: 5, bottom: 5),
                                title: Text(
                                    'Estatus: ${provider.data!.data.estatusSolPrestamo}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 102, 0, 1))),
                                subtitle: Text(
                                    'Solicitud: ${provider.data!.data.fechaSolicitud}\nCapital: \$${formatear.format(provider.data!.data.capital)}\nInterés: \$${formatear.format(provider.data!.data.interes)}\nFondo garantía: \$${formatear.format(provider.data!.data.fg)}\nTotal: \$${formatear.format(provider.data!.data.total)}\nLíquido: \$${formatear.format(provider.data!.data.liquido)}\nPlazo: ${provider.data!.data.plazo}',
                                    style: const TextStyle(fontSize: 14)),
                                leading: const Icon(
                                    Icons.account_balance_wallet,
                                    color: Color.fromARGB(255, 166, 167, 171),
                                    size: 40),
                                /*  trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color.fromRGBO(255, 102, 0, 1),
                            size: 30),*/
                                onTap: () async {
                                  /* Navigator.pushNamed(context, "preregistro",
                            arguments: MensajesArgs(inicioArgs.rfc,
                            inicioArgs.nombre, 'dd', 'dd'));*/
                                },
                              ));
                        } else {
                          return const SizedBox(height: 10);
                        }
                      }),
                    ),

                    ChangeNotifierProvider(
                      create: (context) =>
                          VerificarPagoQuincenalProvider(),
                      child: Consumer<VerificarPagoQuincenalProvider>(
                          builder: (context, provider, child) {
                            if (provider.data == null) {
                              provider.getData(context);
                              return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ));
                            }
                            //INFO: if (provider.data!.data.respuesta == "1") {
                            if (provider.data!.data.pagos == 0 &&
                                provider.data!.data.deposito > 0) {
                              return Card(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 5, top: 5),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(253, 1, 27, 1),
                                          width: 2)),
                                  shadowColor: Colors.brown[300],
                                  elevation: 8,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        top: 2, left: 5, right: 2, bottom: 2),
                                    title:  Text('Pendiente pago Quincena: ${provider.data!.data.quincena}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:  Color.fromRGBO(253, 1, 27, 1))),
                                    subtitle:  Text('Referencia:  ${provider.data!.data.referencia}\nMonto a depositar:  \$${formatear.format(provider.data!.data.deposito)}\nDepositar en:  ${provider.data!.data.depositaren}\nA nombre:  ${provider.data!.data.anombrede}\nConvenio:  ${provider.data!.data.convenio}\nCuenta:  ${provider.data!.data.cuenta}\nCuenta Clabe:  ${provider.data!.data.cuentaClabe}  ',
                                        style: const TextStyle(fontSize: 12, color: Colors.black)),

                                    onTap: () async {

                                    },
                                  ));
                            } else{
                              return const SizedBox(height: 4);
                            }
                          }),
                    ),
                    const SizedBox(height: 30),
                    // Boton de validar
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(255, 102, 0, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        // Con esta instruccion en base al getter se bloquea al boton
                        onPressed: () {
                          eliminarSesion();
                          Navigator.popAndPushNamed(context, 'login');
                        },
                        child: const SizedBox(
                            width: double.infinity,
                            child: Center(child: Text('Cerrar sesion')))),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class _InicioForm extends StatefulWidget {
  // Manejo de estado
  const _InicioForm({Key? key}) : super(key: key);

  @override
  State<_InicioForm> createState() => _InicioFormState();
}

class _InicioFormState extends State<_InicioForm> {
  @override
  void initState() {
    super.initState();
    setState(() {});
    validaSolicitudPrestamo();
  }

  Future<List<Datum>> cargarPrestamos() async {
    const storage = FlutterSecureStorage();

    List<Datum> prestamosCard = [];

    // Recuperar id del empleo
    String? ids = await storage.read(key: 'fkskempleo');
    var id = int.parse(ids!); // Pasar a entero
    // Mapear la solicitud
    final Map<String, dynamic> registroData = {'idEmpleo': id};

    final url = Uri.http(UriConstants.root, UriConstants.postCreditos);
    final postResponse = await http.post(url,
        body: json.encode(registroData),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });

    final creditosResponse = PrestamosCardResponse.fromJson(postResponse.body);

    //debugPrint('postCreditos: $creditosResponse');

    prestamosCard = creditosResponse.data;

    return prestamosCard;
  }

  Future<String> validaSolicitudPrestamo() async {
    const storage = FlutterSecureStorage();
    // Mapear la solicitud
    String ids = await storage.read(key: 'fkskempleo') ?? '0';
    int? fkskempleo;

    fkskempleo = int.tryParse(ids);

    final Map<String, dynamic> authData = {'fkskempleo': fkskempleo};

    final url =
        Uri.http(UriConstants.root, UriConstants.postValidarSolicitudPrestamo);

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
      if (data.containsKey('data')) {
        await storage.write(
            key: 'solicitaPrestamo', value: data['data']['respuesta'] ?? '');

        ////debugPrint(data['mensaje']);

        setState(() {});
        return data['respuesta'] ?? '';
      } else {
        return '0';
      }
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<RegistroFormProvider>(context);

    return Form(
        key: loginForm.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Text('Inicio',
                style: TextStyle(color: Colors.brown[900], fontSize: 25)),
            const SizedBox(height: 20),
            Card(
              margin:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(255, 102, 0, 1), width: 2)),
              shadowColor: Colors.brown[300],
              elevation: 8,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.only(top: 5, left: 8, right: 5, bottom: 5),
                title: const Text('Ir a Prestamos',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 102, 0, 1))),
                subtitle: const Text('Detalle de prestamos',
                    style: TextStyle(fontSize: 14)),
                leading: const Icon(Icons.credit_card_outlined,
                    color: Color.fromRGBO(255, 102, 0, 1), size: 40),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color.fromRGBO(255, 102, 0, 1), size: 30),
                onTap: () async {
                  FocusScope.of(context).unfocus(); // Quitar el teclado

                  Future<List<Datum>> respuesta = cargarPrestamos();

                  respuesta.then((List<Datum> respuesta) async {
                    if (!respuesta.isNotEmpty) {
                      Platform.isIOS
                          // ignore: use_build_context_synchronously
                          ? menssagesUI.displayDialogIos(context, "fabes",
                              'No se cuenta con un préstamo disponibles')
                          // ignore: use_build_context_synchronously
                          : menssagesUI.displayDialogAndroid(context, "fabes",
                              'No se cuenta con un préstamo disponibles.');
                    } else {
                      Navigator.pushNamed(context, "prestamos",
                          arguments: respuesta);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              margin:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(255, 102, 0, 1), width: 2)),
              shadowColor: Colors.brown[300],
              elevation: 8,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.only(top: 5, left: 8, right: 5, bottom: 5),
                title: const Text('Ir a Ahorros',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 102, 0, 1))),
                subtitle: const Text('Detalle de ahorros',
                    style: TextStyle(fontSize: 14)),
                leading: const Icon(Icons.savings_rounded,
                    color: Color.fromRGBO(255, 102, 0, 1), size: 40),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color.fromRGBO(255, 102, 0, 1), size: 30),
                onTap: () async {
                  const storage = FlutterSecureStorage();

                  // Recuperar id del empleo
                  String? ids = await storage.read(key: 'fkskempleo');
                  var id = int.parse(ids!); // Pasar a entero

                  final nombre = await storage.read(key: 'nombre') as String;
                  final rfc = await storage.read(key: 'rfc') as String;
                  final total =
                      await storage.read(key: 'totalAhorrado') as String;

                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, "ahorros_detalle",
                      arguments: AhorrosDetalleArgs(
                          idEmpleo: id,
                          rfc: rfc,
                          nombre: nombre,
                          totalAhorrado: total));
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}
