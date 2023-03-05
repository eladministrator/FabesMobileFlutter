import 'dart:convert';
import 'package:fabes/models/bearer_models.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GridRechazosProvider extends ChangeNotifier {
  PrestamosRechazosResponse? data;

  Future getData(context, int idCredito) async {
    const storage = FlutterSecureStorage();

    String? idEmpleo = await storage.read(key: 'fkskempleo');
    //debugPrint('idEmpleo: $idEmpleo');

    final Map<String, dynamic> registroData = {'idEmpleo': int.tryParse(idEmpleo.toString())};
    final url = Uri.http(UriConstants.root, UriConstants.postRechazos);

    final postResponse = await http.post(url, body: json.encode(registroData), headers: {"Content-Type": "application/json", "Accept": "application/json"});

    data = PrestamosRechazosResponse.fromJson(postResponse.body);

    notifyListeners(); // for callback to view
  }
}
