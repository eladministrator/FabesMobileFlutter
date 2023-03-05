import 'package:flutter/material.dart';

class RecuperarContrasenaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String rfc = '';
  String numeroCelular = '';

  // Propiedad para obtener el valor de la variabel privada de carga
  bool _isLoading = false; // Variable
  bool get isLoading => _isLoading; // Getter
  set isLoading(bool value) {
    // Setter
    _isLoading = value;
    notifyListeners();
  }
  //--

  bool isValidForm() {
    ////debugPrint('Estado del formulario RecuperarContrasenaFormProvider: ${formkey.currentState?.validate()}');
    ////debugPrint('rfc: $rfc, numeroCelular: $numeroCelular');
    return formkey.currentState?.validate() ?? false;
  }
}
