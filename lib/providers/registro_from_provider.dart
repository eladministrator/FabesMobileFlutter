import 'package:flutter/material.dart';

class RegistroFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String correo = '';
  String telefono = '';
  String contrasena = '';
  String contrasenaConfirmada = '';
  String rfc = '';

  // Propiedad para obtener el valor de la variabel privada de carga
  bool _isLoading = false; // Variable
  bool get isLoading => _isLoading; // Getter
  set isLoading(bool value){ // Setter
    _isLoading = value;
    notifyListeners();
  }
  //--

  bool isValidForm(){
    //debugPrint('Estatus formulario RFC: ${ formkey.currentState?.validate()}');
    //debugPrint('Correo: $correo, Telefono: $telefono');
    return formkey.currentState?.validate() ?? false;
  }

}