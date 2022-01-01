import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/scheduler.dart' as ss;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  "High Importance Notifcations",
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message : ${message.messageId}");
  print("Messsage Data:${message.data}");
}

class FirebaseNotifcation {
  // static final GlobalKey<FormState> _formnKey = GlobalKey<FormState>();
  initialize(context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var intializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: intializationSettingsAndroid);

    flutterLocalNotificationplugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      // ss.SchedulerBinding.instance?.addPostFrameCallback((_) {
      //   Navigator.of(GlobalVariable.navState.currentContext!)
      //       .push(MaterialPageRoute(builder: (context) => CommonPage()));
      // });
      // final snackbar = SnackBar(
      //   content: Text(notification!.body!),
      //   action: SnackBarAction(
      //       label: "GO",
      //       onPressed: () {
      //         print("Route");
      //       }),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);

      // await Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => Login()));

      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (_) => DoctorCallHistoryAppointmentScreen()));
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        AndroidNotificationDetails notificationDetails =
            AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.high,
          ledOnMs: 5,
          ongoing: true,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        );

        NotificationDetails notificationDetailsPlatformSpefics =
            NotificationDetails(android: notificationDetails);
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetailsPlatformSpefics,
            payload: "NOTIFICATION_ON_CLICK");
      }

      List<ActiveNotification>? activeNotifications =
          await flutterLocalNotificationplugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.getActiveNotifications();
      if (activeNotifications!.length > 0) {
        List<String> lines =
            activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        AndroidNotificationDetails groupNotificationDetails =
            AndroidNotificationDetails(
          channel.id,
          channel.name,
          styleInformation: inboxStyleInformation,
          setAsGroupSummary: true,
        );

        // NotificationDetails groupNotificationDetailsPlatformSpefics =
        //     NotificationDetails(android: groupNotificationDetails);
        // await flutterLocalNotificationplugin.show(
        //     0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    return token;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
