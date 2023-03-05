import 'dart:convert';

PrestamosPagosResponse welcomeFromMap(String str) =>
    PrestamosPagosResponse.fromMap(json.decode(str));

String welcomeToMap(PrestamosPagosResponse data) => json.encode(data.toMap());

class PrestamosPagosResponse {
  PrestamosPagosResponse({
    required this.prestamosPagosResult,
    required this.data,
  });

  Result prestamosPagosResult;

  List<DatumPagos> data;

  factory PrestamosPagosResponse.fromJson(String str) =>
      PrestamosPagosResponse.fromMap(json.decode(str));

  factory PrestamosPagosResponse.fromMap(Map<String, dynamic> json) =>
      PrestamosPagosResponse(
        prestamosPagosResult: Result.fromMap(json["result"]),
        data: List<DatumPagos>.from(
            json["data"].map((x) => DatumPagos.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": prestamosPagosResult.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class DatumPagos {
  DatumPagos({
    required this.quincenadeaplicacion,
    required this.nombre,
    required this.descuentototal,
    required this.id,
  });

  int quincenadeaplicacion;
  String nombre;
  double descuentototal;
  int id;

  factory DatumPagos.fromMap(Map<String, dynamic> json) => DatumPagos(
        quincenadeaplicacion: json["quincenadeaplicacion"],
        nombre: json["nombre"],
        descuentototal: json["descuentototal"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "quincenadeaplicacion": quincenadeaplicacion,
        "nombre": nombre,
        "descuentototal": descuentototal,
        "id": id,
      };
}

class Result {
  Result({
    required this.codeNumber,
    required this.codeDescription,
    required this.error,
    required this.status,
  });

  dynamic codeNumber;
  dynamic codeDescription;
  dynamic error;
  bool status;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        codeNumber: json["codeNumber"],
        codeDescription: json["codeDescription"],
        error: json["error"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "codeNumber": codeNumber,
        "codeDescription": codeDescription,
        "error": error,
        "status": status,
      };
}
