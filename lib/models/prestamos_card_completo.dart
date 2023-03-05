import 'package:fabes/models/prestamos_card_response.dart' show Datum;

class PrestamosCardCompletoResponse {
  String rfc = "";
  String nombre = "";
  List<Datum> data = [];

  PrestamosCardCompletoResponse({required rfc, required nombre, required data});
}
