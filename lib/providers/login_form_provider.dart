import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';

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
    //debugPrint('Estado del formulario: ${formkey.currentState?.validate()}');
    //debugPrint('Email: $email, Password: $password');
    return formkey.currentState?.validate() ?? false;
  }
}
