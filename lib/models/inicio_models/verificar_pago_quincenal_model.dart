import 'dart:convert';
import 'package:fabes/providers/verificar_pago_quincenal.dart';

import '../global_models/result_response.dart';

VerificarPagoQuincenal rechazosFromMap(String str) => VerificarPagoQuincenal.fromMap(json.decode(str));

String rechazosToMap(VerificarPagoQuincenal data) => json.encode(data.toMap());

class VerificarPagoQuincenal {

  VerificarPagoQuincenal({
    required this.result,
    required this.data,
  });

  Result result;
  Data data;

  factory VerificarPagoQuincenal.fromJson(String str) => VerificarPagoQuincenal.fromMap(json.decode(str));

  factory VerificarPagoQuincenal.fromMap(Map<String, dynamic> json) => VerificarPagoQuincenal(
    result: Result.fromMap(json["result"]),
    data: Data.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {"result": result.toMap(), "data": data.toMap()};
}

class Data {
  Data({
    required this.quincena,
    required this.pagos,
    required this.deposito,
    required this.referencia,
    required this.depositaren,
    required this.anombrede,
    required this.convenio,
    required this.cuenta,
    required this.cuentaClabe,
    required this.id
  });

  int quincena;
  int pagos;
  double deposito;
  String referencia;
  String depositaren;
  String anombrede;
  String convenio;
  String cuenta;
  String cuentaClabe;
  int id;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    quincena: json["quincena"].toInt(),
    pagos: json["pagos"].toInt(),
    deposito: json["deposito"].toDouble(),
    referencia: json["referencia"],
    depositaren: json["depositaren"],
    anombrede: json["anombrede"],
    convenio: json["convenio"],
    cuenta: json["cuenta"],
    cuentaClabe: json["cuentaClabe"],
    id: json["id"].toInt(),
  );

  Map<String, dynamic> toMap() => {
    "quincena": quincena,
    "pagos": pagos,
    "deposito": deposito,
    "referencia": referencia,
    "depositaren": depositaren,
    "anombrede": anombrede,
    "convenio": convenio,
    "cuenta": cuenta,
    "cuentaClabe": cuentaClabe,
    "id": id
  };
}
