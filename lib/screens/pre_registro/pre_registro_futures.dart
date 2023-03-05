import 'dart:convert';
import 'package:fabes/screens/pre_registro/pre_registro_screen.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/ui/messages_ui.dart';
import 'package:fabes/utils/parse_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> postRegistrarSolicitudPrestamo(String xidPrestamo) async {
  MenssagesUI menssagesUI = MenssagesUI();
  const storage = FlutterSecureStorage();
  try {
    String? xfkskempleo = await storage.read(key: 'fkskempleo');

    var fkskempleo = int.parse(xfkskempleo!);
    var idPrestamo = int.parse(xidPrestamo);

    final url = Uri.http(UriConstants.root, UriConstants.postRegistrarSolicitudPrestamo);

    final Map<String, dynamic> payload = {
      'idEmpleo': fkskempleo,
      'idPrestamo': idPrestamo
    };

    final response = await http.post(url, body: json.encode(payload), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

        if (data["data"]["capital"] != null) {
          return "ok";
        }else{
          return  "err";
        }


    } else {
        return  "err";
    }

  } catch (e) {
      //debugPrint(' CATCH: $e');
      return "err";
  }
}
