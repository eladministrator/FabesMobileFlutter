import 'dart:convert';

class PrestamosCardResponse {
  PrestamosCardResponse({required this.result, required this.data});

  Result result;
  List<Datum> data;

  factory PrestamosCardResponse.fromJson(String str) => PrestamosCardResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrestamosCardResponse.fromMap(Map<String, dynamic> json) => PrestamosCardResponse(
        result: Result.fromMap(json["result"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": result.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  Datum(
      {required this.estatus,
      required this.folio,
      required this.plazo,
      required this.capital,
      required this.interes,
      required this.fg,
      required this.descuentoquincenal,
      required this.fecha,
      required this.quincenainicial,
      required this.quincenafinal,
      required this.total,
      required this.pagado,
      required this.saldo,
      required this.id,
      required this.fkckmododedescuento,
      required this.tipoDescuento
      //required this.nombre,
      //required this.rfc
      });

  String estatus;
  String folio;
  int plazo;
  double capital;
  double interes;
  double fg;
  double descuentoquincenal;
  String fecha;
  int quincenainicial;
  int quincenafinal;
  double total;
  double pagado;
  double saldo;
  int id;
  int fkckmododedescuento;
  String tipoDescuento;
  //--
  //String nombre = 'Omar Cervantes';
  //String rfc = 'CEGO800509CT6';

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        estatus: json["estatus"],
        folio: json["folio"],
        plazo: json["plazo"],
        capital: json["capital"],
        interes: json["interes"].toDouble(),
        fg: json["fg"],
        descuentoquincenal: json["descuentoquincenal"].toDouble(),
        //fecha: DateTime.parse(json["fecha"]),
        fecha: json["fecha"],
        quincenainicial: json["quincenainicial"],
        quincenafinal: json["quincenafinal"],
        total: json["total"].toDouble(),
        pagado: json["pagado"].toDouble(),
        saldo: json["saldo"].toDouble(),
        id: json["id"],
        fkckmododedescuento: json["fkckmododedescuento"],
        tipoDescuento: json["tipoDescuento"],
        //--
        //nombre: 'Omar Cervantes', //json["id"],
        // rfc: 'CEGO800509CT6' //json["id"],
      );

  Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "folio": folio,
        "plazo": plazo,
        "capital": capital,
        "interes": interes,
        "fg": fg,
        "descuentoquincenal": descuentoquincenal,
        "fecha": fecha,
        "quincenainicial": quincenainicial,
        "quincenafinal": quincenafinal,
        "total": total,
        "pagado": pagado,
        "saldo": saldo,
        "id": id,
        "fkckmododedescuento": fkckmododedescuento,
        "tipoDescuento": tipoDescuento
      };
}

class Result {
  Result({
    this.codeNumber,
    this.codeDescription,
    this.error,
    required this.status,
  });

  dynamic codeNumber;
  dynamic codeDescription;
  dynamic error;
  bool status;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

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
