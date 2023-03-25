import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/app/app.logger.dart';
import 'package:weather_app/app/app.router.dart';
import 'package:weather_app/app/service_locator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService{
  String navigationId = '';
  bool enabled =  false;
   FlutterLocalNotificationsPlugin? _localNotificationService;
   StreamController<String?>? selectNotificationStream;
   StreamController<ReceivedNotification?>? didReceiveNotificationStream;
  final log = getLogger('localNotification service');
  LocalNotificationService(){
tz.initializeTimeZones();
    _localNotificationService = FlutterLocalNotificationsPlugin();
     selectNotificationStream =  StreamController<String?>.broadcast();
     didReceiveNotificationStream =  StreamController<ReceivedNotification?>.broadcast();
    requestPermission();
     _configureDidReceiveLocalNotificationSubject();
     _configureSelectNotificationSubject();
    log.i('local registered');
  }
  // String navigationId = '';
  // bool enabled =  false;
  // final _localNotificationService = FlutterLocalNotificationsPlugin();
  // final StreamController<String?> selectNotificationStream =  StreamController<String?>.broadcast();
  // final StreamController<ReceivedNotification?> didReceiveNotificationStream =  StreamController<ReceivedNotification?>.broadcast();


  void requestPermission()async{
    if(Platform.isIOS || Platform.isMacOS){
      await _localNotificationService!.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await _localNotificationService!.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    else if(Platform.isAndroid){
     enabled =  await _localNotificationService!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled()??false;
    }
  }

   Future initialize()async{

     const AndroidInitializationSettings androidSetting = AndroidInitializationSettings('mipmap/notification');
     final DarwinInitializationSettings iosAndMacosSetting = DarwinInitializationSettings(
       requestAlertPermission: true,
       requestBadgePermission: false,
       requestSoundPermission: true,
       onDidReceiveLocalNotification: onDidReceiveLocalNotification
     );
     final InitializationSettings settings = InitializationSettings(
         android: androidSetting,
       iOS: iosAndMacosSetting,
       macOS: iosAndMacosSetting
     );

     await _localNotificationService!.initialize(settings,
       onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotification,
       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
     );
   }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async{
     debugPrint(payload);
     didReceiveNotificationStream!.add(ReceivedNotification(id: id, title: title, body: body, payload: payload));
  }


  static onDidReceiveBackgroundNotification(NotificationResponse notificationResponse) {

  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    switch(notificationResponse.notificationResponseType){
      case NotificationResponseType.selectedNotification:
        selectNotificationStream!.add(notificationResponse.payload);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if(notificationResponse.actionId ==navigationId){
          selectNotificationStream!.add(notificationResponse.payload);
        }
        break;

    }
  }

  _configureDidReceiveLocalNotificationSubject(){
     didReceiveNotificationStream!.stream.listen((event) {
       debugPrint('expected to navigate');
       navigationService.navigateToHomePageView();
     });
  }

  _configureSelectNotificationSubject(){
    selectNotificationStream!.stream.listen((event) {
      debugPrint('expected to event');
      debugPrint(event);
    });
  }

  Future showNotification()async{
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('shevy', 'here',
    channelDescription:'best in weather forecast',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true);

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.critical,
     presentSound: true,
      presentAlert: true,
      presentBadge: true,
      subtitle: 'best in weather forecast',


    );
    const NotificationDetails  notificationDetails = NotificationDetails(android: androidNotificationDetails,iOS:
    darwinNotificationDetails,
        macOS: darwinNotificationDetails,

    );
    _localNotificationService!.zonedSchedule(1, 'welcome', 'best in weather forecast',
        tz.TZDateTime.from(DateTime.now().add(const Duration(seconds: 10)), tz.local),
        notificationDetails, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true);
  }

  Future<void> showNotificationWithActions() async {
     AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          navigationId,
          'Action 1',
          icon: const DrawableResourceAndroidBitmap('mipmap/notification'),
          contextual: true,
        ),
        const AndroidNotificationAction(
          'id_2',
          'Action 2',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('mipmap/notification'),
        ),
        const AndroidNotificationAction(
          'id_3',
          'Action 3',
          icon: DrawableResourceAndroidBitmap('mipmap/notification'),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],
    );

     NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );
    await _localNotificationService!.show(
        2, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

}
class ReceivedNotification{
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,required
    this.payload,


});
  final int id;
  final String? title;
  final String? body;
  final String? payload;
}