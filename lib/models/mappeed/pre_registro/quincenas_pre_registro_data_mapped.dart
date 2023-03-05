import 'dart:convert';

class QuincenasPreRegistroDataMapped {
  QuincenasPreRegistroDataMapped({
    required this.nombre,
    required this.id,
  });

  dynamic nombre; // Descripcion de la quincena
  dynamic id; // Id de la quincena

  factory QuincenasPreRegistroDataMapped.fromJson(String str) =>
      QuincenasPreRegistroDataMapped.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuincenasPreRegistroDataMapped.fromMap(Map<String, dynamic> json) =>
      QuincenasPreRegistroDataMapped(
        nombre: json["nombre"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "id": id,
      };
}
