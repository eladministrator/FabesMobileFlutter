class AhorrosDetalleArgs {
  final int idEmpleo;
  final String nombre;
  final String rfc;
  final String totalAhorrado;

  AhorrosDetalleArgs(
      {this.idEmpleo = 0,
      this.nombre = '-',
      this.rfc = '-',
      this.totalAhorrado = '0'});
}
