
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fuodz/services/firebase.service.dart';

class GeneralAppService {
  //

//Hnadle background message
  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    FirebaseService().saveNewNotification(message);
    //normal notifications
    FirebaseService().showNotification(message);
  }
}
