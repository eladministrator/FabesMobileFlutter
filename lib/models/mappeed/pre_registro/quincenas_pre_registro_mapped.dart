//ValidaSolicitarNuevoPrestamoResponse
import 'dart:convert';
import '../../global_models/result_response.dart';
import '../pre_registro/quincenas_pre_registro_data_mapped.dart';

// QuincenasPreRegistroMapped rechazosFromMap(String str) =>
//     QuincenasPreRegistroMapped.fromMap(json.decode(str));

// String rechazosToMap(QuincenasPreRegistroMapped data) =>
//     json.encode(data.toMap());

class QuincenasPreRegistroMapped {
  QuincenasPreRegistroMapped({
    required this.result,
    required this.data,
  });

  Result result;
  List<QuincenasPreRegistroDataMapped> data;

  factory QuincenasPreRegistroMapped.fromJson(String str) =>
      QuincenasPreRegistroMapped.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuincenasPreRegistroMapped.fromMap(Map<String, dynamic> json) =>
      QuincenasPreRegistroMapped(
        result: Result.fromMap(json["result"]),
        data: List<QuincenasPreRegistroDataMapped>.from(
            json["data"].map((x) => QuincenasPreRegistroDataMapped.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": result.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap()))
      };
}
