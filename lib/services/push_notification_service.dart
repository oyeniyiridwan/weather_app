import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService{


  Future initialize()async{
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    // NotificationSettings settings =
    await fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    // if(settings.authorizationStatus == AuthorizationStatus.authorized){
    //
    // }
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     debugPrint('got a message in foreground: ${message.data}');
     if(message.notification!=null){
       debugPrint('message contains notification: ${message.notification}');

     }
   });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('got a message in onLaunch: ${message.data}');
      if(message.notification!=null){
        debugPrint('message contains notification: ${message.notification}');

      }
    });
  }
}
