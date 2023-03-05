import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  // Este es para estar escuchando los stream y poder subscribirse en cualquier parte de
  // la aplicacion.
  static final StreamController<String> _messageStream = StreamController.broadcast();
  // Getter para message stream
  static Stream<String> get messageStream => _messageStream.stream;
  //--

  static Future _backgroundHandler(RemoteMessage message) async {
    debugPrint('BACKGROUND HANDLER: ${message.data}');
    //_messageStream.add(message.notification?.title ?? '');
    _messageStream.add(message.data['internalvalue'] ?? '');
  }

  // Este evento se dispara cuando la app esta cerrada
  static Future _onMessageHandler(RemoteMessage message) async {
    debugPrint('_ONMESSAGEHANDLER: ${message.data}');
    //_messageStream.add(message.notification?.title ?? '');
    _messageStream.add(message.data['internalvalue'] ?? '');
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    debugPrint('_ONMESSAGEOPENAPPHANDLER: ${message.data}');
    //_messageStream.add(message.notification?.title ?? '');
    _messageStream.add(message.data['internalvalue'] ?? '');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    const storage = FlutterSecureStorage();
    token = await FirebaseMessaging.instance.getToken();
    await storage.write(key: 'tokenFirebase', value: token);

    debugPrint('TOKEN: $token');

    // Escuchar los eventos de las notificaciones push
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // Este evento se dispara cuando la app esta cerrada
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);
  }

  // Cierra la subscripción al objeto, no es obligatorio pero se marca
  // como recomendable
  static closeStreams() {
    _messageStream.close();
  }
}

//F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
/**
 * Variant: debug
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------
Variant: release
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------
Variant: profile
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------

> Task :flutter_plugin_android_lifecycle:signingReport
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------

> Task :flutter_secure_storage:signingReport
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
----------

> Task :local_auth_android:signingReport
Variant: debugAndroidTest
Config: debug
Store: C:\Users\Omarcko\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 97:54:63:13:5A:44:F1:4B:D0:4B:65:DA:5B:C1:B3:94
SHA1: F5:8A:21:6D:D3:EA:DD:9B:4F:8F:44:77:FB:3C:5C:CF:20:0A:DD:CA
SHA-256: EC:80:F2:12:B1:06:77:B8:52:64:E2:8D:AE:0C:D1:14:67:0F:6F:1D:F5:69:0B:05:37:86:D2:5D:1A:4F:92:08
Valid until: Saturday, August 31, 2052
 */
