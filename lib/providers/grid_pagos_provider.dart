import 'dart:convert';
import 'package:fabes/models/bearer_models.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class GridPagosProvider extends ChangeNotifier {
  PrestamosPagosResponse? data;

  Future getData(context, int idCredito) async {
    final Map<String, dynamic> registroData = {'idCredito': idCredito};
    final url = Uri.http(UriConstants.root, UriConstants.postPagos);

    final postResponse = await http.post(url, body: json.encode(registroData), headers: {"Content-Type": "application/json", "Accept": "application/json"});

    data = PrestamosPagosResponse.fromJson(postResponse.body);

    notifyListeners(); // for callback to view
  }
}
