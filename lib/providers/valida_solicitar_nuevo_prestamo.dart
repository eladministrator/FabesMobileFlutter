import 'dart:convert';
//import 'package:fabes/models/bearer_models.dart';
import 'package:fabes/models/inicio_models/valida_solicitar_nuevo_prestamo_response.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ValidaSolicitarNuevoPrestamoProvider extends ChangeNotifier {
  ValidaSolicitarNuevoPrestamoResponse? data;

  Future getData(context) async {
    const storage = FlutterSecureStorage();
    String? idEmpleo = await storage.read(key: 'fkskempleo');
    //debugPrint('ELEMPLEO: $idEmpleo ');
    final Map<String, dynamic> registroData = {'fkskempleo': int.tryParse(idEmpleo.toString())};
    final url = Uri.http(UriConstants.root, UriConstants.postValidarSolicitudPrestamo);

    final postResponse = await http.post(url, body: json.encode(registroData), headers: {"Content-Type": "application/json", "Accept": "application/json"});

    data = ValidaSolicitarNuevoPrestamoResponse.fromJson(postResponse.body);

    notifyListeners(); // for callback to view
  }

}
