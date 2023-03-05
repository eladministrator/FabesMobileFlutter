import 'package:flutter/material.dart';

class RfcFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
    //debugPrint('RFC: $rfc');
    return formkey.currentState?.validate() ?? false;
  }



}