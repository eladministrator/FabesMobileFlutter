import 'package:fabes/models/mappeed/pre_registro/quincenas_pre_registro_mapped.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class QuincenasValidasProvider extends ChangeNotifier {
  QuincenasPreRegistroMapped? data;

  Future getData(context) async {
    final url = Uri.http(UriConstants.root, UriConstants.postListaQuincenas);
    // final response = await http.post(url, body: json.encode(envio), headers: {
    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    ////debugPrint('PROVIDER: iniciado...');
    //debugPrint('PROVIDER: ${response.body}');
    data = QuincenasPreRegistroMapped.fromJson(response.body);

    notifyListeners(); // for callback to view
  }
}
