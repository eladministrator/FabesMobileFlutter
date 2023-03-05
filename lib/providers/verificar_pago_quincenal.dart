import 'dart:convert';
//import 'package:fabes/models/bearer_models.dart';
import 'package:fabes/models/inicio_models/valida_solicitar_nuevo_prestamo_response.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/inicio_models/verificar_pago_quincenal_model.dart';

class VerificarPagoQuincenalProvider extends ChangeNotifier {
  VerificarPagoQuincenal? data;

  Future getData(context) async {
    const storage = FlutterSecureStorage();
    String? idEmpleo = await storage.read(key: 'fkskempleo');


    final url = Uri.http(UriConstants.root, '${UriConstants.getVerificarPagoQuincenal}$idEmpleo');

    final postResponse = await http.get(url, headers: {"Accept": "*/*"});


    data = VerificarPagoQuincenal.fromJson(postResponse.body);

    notifyListeners(); // for callback to view
  }

}
