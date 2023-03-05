import 'dart:convert';

class AhorrosResponse {
  AhorrosResponse({
    required this.result,
    required this.data,
  });

  AhorrosResult result;
  List<Ahorros> data;

  factory AhorrosResponse.fromJson(String str) =>
      AhorrosResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AhorrosResponse.fromMap(Map<String, dynamic> json) => AhorrosResponse(
        result: AhorrosResult.fromMap(json["result"]),
        data: List<Ahorros>.from(json["data"].map((x) => Ahorros.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": result.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Ahorros {
  Ahorros({
    required this.quincena,
    required this.tipo,
    required this.monto,
    required this.interes,
    required this.id,
  });

  int quincena;
  String tipo;
  double monto;
  double interes;
  int id;

  factory Ahorros.fromJson(String str) => Ahorros.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ahorros.fromMap(Map<String, dynamic> json) => Ahorros(
        quincena: json["quincena"],
        tipo: json["tipo"],
        monto: json["monto"].toDouble(),
        interes: json["interes"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "quincena": quincena,
        "tipo": tipo,
        "monto": monto,
        "interes": interes,
        "id": id,
      };
}

class AhorrosResult {
  AhorrosResult({
    required this.codeNumber,
    required this.codeDescription,
    required this.error,
    required this.status,
  });

  dynamic codeNumber;
  dynamic codeDescription;
  dynamic error;
  bool status;

  factory AhorrosResult.fromJson(String str) =>
      AhorrosResult.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AhorrosResult.fromMap(Map<String, dynamic> json) => AhorrosResult(
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
