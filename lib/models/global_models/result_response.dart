import 'dart:convert';

// Clase: Para mapear la respuesta de los endpoint
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
