import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdateAppUI {
  // Detectar si se requiere actualizacion de la app
  Future<String> fnUpdateApp() async {
    const storage = FlutterSecureStorage();
    String? actualizar;

    try {
      actualizar = await storage.read(key: 'actualizar');
      debugPrint('fnUpdateApp() actualizar: $actualizar');
    } catch (e) {
      debugPrint('ERROR UpdateAppUI.fnUpdateApp(): $e');
    }

    return actualizar!;
  }
}
