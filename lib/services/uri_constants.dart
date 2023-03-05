class UriConstants {
  static const root = 'apifabesmobile.ghura.com.mx';
  static const String postAuthenticaction = 'api/authentication';
  static const String getValidarRFC = 'api/validarfcfabes/';
  static const String postRegistro = 'api/registro/';
  static const String postTwilio = 'api/twilio/';
  static const String postActivacion = 'api/registro/activacion';
  static const String postCreditos = 'api/creditos';
  static const String postPagos = 'api/pagos';
  static const String postGridAhorros = 'api/ahorros';
  static const String postRecuperarContrasena = 'api/Twilio/contrasena';
  static const String postVersiones = 'api/versiones/';
  static const String postValidarSolicitudPrestamo = 'api/nuevoprestamo';
  static const String postRechazos = 'api/rechazos';
  static const String postActivarCuenta = 'api/activacuenta';

  //http://apifabesmobile.ghura.com.mx/api/catalogos
  static const String postListaQuincenas = 'api/catalogos';

  //http://apifabesmobile.ghura.com.mx/api/catalogos/capital
  /*
    {
      "Liquido": 700,
      "idPlazo": 2
    }
   */
  static const String postCapitalDisponible = 'api/catalogos/capital';

  static const String postRegistrarSolicitudPrestamo = 'api/creditos/addprestamo';
  static const String getVerificarPagoQuincenal = 'api/quincenasinpago/';


}
