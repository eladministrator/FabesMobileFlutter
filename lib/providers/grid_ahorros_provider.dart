import 'dart:convert';
import 'package:fabes/services/uri_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/ahorros_response.dart';

class GridAhorrosProvider extends ChangeNotifier {
  AhorrosResponse? data;

  Future getData(context, int idEmpleo) async {
    final Map<String, dynamic> registroData = {'idEmpleo': idEmpleo};

    final url = Uri.http(UriConstants.root, UriConstants.postGridAhorros);

    final postResponse = await http.post(url,
        body: json.encode(registroData),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });

    data = AhorrosResponse.fromJson(postResponse.body);

    ////debugPrint('GridAhorrosProvider url: $url');
    ////debugPrint('GridAhorrosProvider url: $url');
    ////debugPrint('GridAhorrosProvider postResponse.body : ${postResponse.body}');

    notifyListeners(); // for callback to view
  }
}
