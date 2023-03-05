import 'package:flutter/material.dart';

class ActivacionCuentaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String rfc = '';
  String telefono = '';
  String correo = '';

  //!: Propiedad para obtener el valor de la variabel privada de carga
  bool _isLoading = false; // Variable
  bool get isLoading => _isLoading; // Getter
  set isLoading(bool value) {
    // Setter
    _isLoading = value;
    notifyListeners();
  }
  //--

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
