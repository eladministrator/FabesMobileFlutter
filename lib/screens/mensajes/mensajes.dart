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

class MensajesScreen extends StatefulWidget {
  const MensajesScreen({Key? key}) : super(key: key);

  @override
  State<MensajesScreen> createState() => _MensajesScreenState();
}

class _MensajesScreenState extends State<MensajesScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MensajesArgs;
    final splitMessage = args.mensaje.split('|');
    var formatear = NumberFormat('###,###.00', 'en_US');

    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: BackgroundWidget(
          // child2: Pasa el nombre y rfc al widget del background
          topLogo: 70,
          topChild2: 150,
          child2: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                //widthFactor: 1,
                child: Text(
                  args.nombre,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.brown),
                  //textAlign: TextAlign.center,
                ),
              ),
              Center(
                  child: Text(
                args.rfc,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Roboto', color: Colors.brown),
              ))
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 75),
                CardContainerSmWidget(
                    child: Column(
                  children: [
                    //const SizedBox(height: 5),
                    //Text('Bandeja de mensajes', style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                    //const SizedBox(height: 10),
                    Card(
                      margin: const EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 5),
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.brown, width: 1)),
                      shadowColor: Colors.brown[300],
                      elevation: 8,
                      child: ListTile(
                        title: const Text('Aviso Importante\n', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 102, 0, 1))),
                        subtitle: Text('${splitMessage[0]}\n\n${splitMessage[1]}\n\n${splitMessage[2]}\n${splitMessage[3]}\$${formatear.format(double.tryParse(splitMessage[4]))}\n${splitMessage[5]}\n${splitMessage[6]}\n${splitMessage[7]}\n${splitMessage[8]}\n${splitMessage[9]}',
                            textAlign: TextAlign.left, style: const TextStyle(fontSize: 15)),
                        //leading: const Icon(Icons.credit_card, color: Color.fromRGBO(255, 102, 0, 1), size: 40),
                        //trailing: const Icon(Icons.warning_rounded, color: Color.fromRGBO(255, 102, 0, 1), size: 30),
                        onTap: () async {},
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 102, 0, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        // Con esta instruccion en base al getter se bloquea al boton
                        onPressed: () async {
                          const storage = FlutterSecureStorage();
                          String? solicitaPrestamo = await storage.read(key: 'solicitaPrestamo');
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, 'inicio', arguments: InicioArgs(args.rfc, args.nombre, solicitaPrestamo ?? ''));
                        },
                        child: const SizedBox(width: double.infinity, child: Center(child: Text('Enterado, gracias')))),
                    const SizedBox(height: 5),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
