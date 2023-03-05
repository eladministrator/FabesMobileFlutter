//ValidaSolicitarNuevoPrestamoResponse
import 'dart:convert';
import '../global_models/result_response.dart';

ValidaSolicitarNuevoPrestamoResponse rechazosFromMap(String str) => ValidaSolicitarNuevoPrestamoResponse.fromMap(json.decode(str));

String rechazosToMap(ValidaSolicitarNuevoPrestamoResponse data) => json.encode(data.toMap());

class ValidaSolicitarNuevoPrestamoResponse {
  ValidaSolicitarNuevoPrestamoResponse({
    required this.result,
    required this.data,
  });

  Result result;
  Data data;

  factory ValidaSolicitarNuevoPrestamoResponse.fromJson(String str) => ValidaSolicitarNuevoPrestamoResponse.fromMap(json.decode(str));

  factory ValidaSolicitarNuevoPrestamoResponse.fromMap(Map<String, dynamic> json) => ValidaSolicitarNuevoPrestamoResponse(
        result: Result.fromMap(json["result"]),
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"result": result.toMap(), "data": data.toMap()};
}

class Data {
  Data({
    required this.fkskempleo,
    required this.respuesta,
    required this.id,
    required this.fechaSolicitud,
    required this.estatusSolPrestamo,
    required this.capital,
    required this.interes,
    required this.fg,
    required this.total,
    required this.descuentoQuincenal,
    required this.liquido,
    required this.plazo,
  });

  int fkskempleo;
  String respuesta;
  int id;
  String fechaSolicitud;
  String estatusSolPrestamo;
  double capital;
  double interes;
  double fg;
  double total;
  double descuentoQuincenal;
  double liquido;
  String plazo;


  factory Data.fromMap(Map<String, dynamic> json) => Data(
        fkskempleo: json["fkskempleo"],
        respuesta: json["respuesta"],
        id: json["id"],
        fechaSolicitud: json["fechaSolicitud"],
        estatusSolPrestamo: json["estatusSolPrestamo"],
        capital: json["capital"].toDouble(),
    interes: json["interes"].toDouble(),
    fg: json["fg"].toDouble(),
    total: json["total"].toDouble(),
    descuentoQuincenal: json["descuentoQuincenal"].toDouble(),
    liquido: json["liquido"].toDouble(),
    plazo: json["plazo"],
      );

  Map<String, dynamic> toMap() => {
        "fkskempleo": fkskempleo,
        "respuesta": respuesta,
        "id": id,
        "fechaSolicitud": fechaSolicitud,
    "estatusSolPrestamo": estatusSolPrestamo,
    "capital": capital,
    "interes": interes,
    "fg": fg,
    "total": total,
    "descuentoQuincenal": descuentoQuincenal,
    "liquido": liquido,
    "plazo": plazo,
      };
}
