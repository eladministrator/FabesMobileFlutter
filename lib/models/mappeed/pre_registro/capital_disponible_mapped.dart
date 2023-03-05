class CapitalDisponibleMapped {
  CapitalDisponibleMapped({
    required this.nombre,
    required this.id,
  });

  String nombre; // Descripcion de la quincena
  int id; // Id de la quincena

  factory CapitalDisponibleMapped.fromJson(Map<String, dynamic> json) {
    return CapitalDisponibleMapped(
      nombre: json["nombre"],
      id: json["id"],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory CapitalDisponibleMapped.fromMap(Map<String, dynamic> json) =>
  //     CapitalDisponibleMapped(
  //       nombre: json["nombre"],
  //       id: json["id"],
  //     );

  // Map<String, dynamic> toMap() => {
  //       "nombre": nombre,
  //       "id": id,
  //     };
}
