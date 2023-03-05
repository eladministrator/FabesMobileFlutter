import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LoginHttpService extends ChangeNotifier {
  LoginHttpService() {
    // ignore: unused_local_variable
    //postValidarVersion();
  }

  // Future<String> postValidarVersion() async {
  //   var url = Uri.http('apifabesmobile.ghura.com.mx', 'api/versiones');
  //   var body = jsonEncode({'activa': 1});
  //   const miVersion = '1.03';
  //   const storage = FlutterSecureStorage();

  //   try {
  //     var response = await http.post(url, body: body, headers: {"Content-Type": "application/json", "Accept": "application/json"});
  //     final Map<String, dynamic> data = json.decode(response.body);

  //     //debugPrint('Response status: ${response.statusCode}');
  //     //debugPrint('Response body: ${response.body}');
  //     //debugPrint('Decode: ${data['data']['version']}');
  //     //debugPrint('Decode: ${data['data']['activa']}');
  //     //debugPrint('Decode: ${data['data']['id']}');

  //     if (response.statusCode.toString() == '200') {
  //       final versionServidor = data['data']['version'];
  //       final estatus = data['data']['activa'];

  //       // Indica que no se debe de actualizar
  //       if (miVersion == versionServidor && estatus == 1) {
  //         //debugPrint('postValidarVersion actualizar = 0');
  //         await storage.write(key: 'actualizar', value: '0');
  //       }

  //       // Indica que no se puede ingresar
  //       if (miVersion == versionServidor && estatus == 2) {
  //         //debugPrint('postValidarVersion actualizar = 2');
  //         await storage.write(key: 'actualizar', value: '2');
  //       }

  //       // Indica que hay un cambio de version y se debe de actualizar
  //       if (miVersion != versionServidor && estatus == 1) {
  //         ////debugPrint('postValidarVersion actualizar = 1');
  //         await storage.write(key: 'actualizar', value: '1');
  //       }
  //       return miVersion;
  //     } else {
  //       return 'Por el momento el servicio no esta disponible. Por favor intente más tarde.';
  //     }
  //   } catch (e) {
  //     //debugPrint('ERROR postValidarVersion(): $e');
  //     return 'x';
  //   }
  // }
}
