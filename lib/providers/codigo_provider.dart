import 'package:flutter/material.dart';

class CodigoFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String codigo = '';

  // Propiedad para obtener el valor de la variabel privada de carga
  bool _isLoading = false; // Variable
  bool get isLoading => _isLoading; // Getter
  set isLoading(bool value){ // Setter
    _isLoading = value;
    notifyListeners();
  }
  //--

  bool isValidForm(){
    //debugPrint('Codigo: $codigo');
    return formkey.currentState?.validate() ?? false;
  }



}