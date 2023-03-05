import 'dart:convert';

PrestamosRechazosResponse rechazosFromMap(String str) => PrestamosRechazosResponse.fromMap(json.decode(str));

String rechazosToMap(PrestamosRechazosResponse data) => json.encode(data.toMap());

class PrestamosRechazosResponse {
  PrestamosRechazosResponse({
    required this.prestamosRechazosResult,
    required this.data,
  });

  ResultRechazos prestamosRechazosResult;

  List<DatumRechazos> data;

  factory PrestamosRechazosResponse.fromJson(String str) => PrestamosRechazosResponse.fromMap(json.decode(str));

  factory PrestamosRechazosResponse.fromMap(Map<String, dynamic> json) => PrestamosRechazosResponse(
        prestamosRechazosResult: ResultRechazos.fromMap(json["result"]),
        data: List<DatumRechazos>.from(json["data"].map((x) => DatumRechazos.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": prestamosRechazosResult.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class DatumRechazos {
  DatumRechazos({
    required this.fecha,
    required this.nombre,
    required this.monto,
    required this.id,
  });

  String fecha;
  String nombre;
  double monto;
  int id;

  factory DatumRechazos.fromMap(Map<String, dynamic> json) => DatumRechazos(
        fecha: json["fecha"],
        nombre: json["nombre"],
        monto: json["monto"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "fecha": fecha,
        "nombre": nombre,
        "monto": monto,
        "id": id,
      };
}

class ResultRechazos {
  ResultRechazos({
    required this.codeNumber,
    required this.codeDescription,
    required this.error,
    required this.status,
  });

  dynamic codeNumber;
  dynamic codeDescription;
  dynamic error;
  bool status;

  factory ResultRechazos.fromJson(String str) => ResultRechazos.fromMap(json.decode(str));

  factory ResultRechazos.fromMap(Map<String, dynamic> json) => ResultRechazos(
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
