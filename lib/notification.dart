import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_and_doctor_appointment/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationSetUp {
  final FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
  User? user;

  Future<void> initializeNotification() async {
    AwesomeNotifications().initialize('resource://drawable/res_laucher_icon', [
      NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Chat notifications',
          importance: NotificationImportance.Max,
          vibrationPattern: highVibrationPattern,
          channelDescription: 'Chat notifications.',
          channelShowBadge: true)
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void getIOSPermission() {
    _firebaseMessage.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  void configurePushNotifications(BuildContext context) async {
    initializeNotification();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) getIOSPermission();

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("==========${message.notification!.body}==========");
      if (message.notification != null) {
        createOrderNotifications(
          title: message.notification!.title,
          body: message.notification!.body,
        );
      }
    });
  }

  Future<void> createOrderNotifications({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        icon: "",
      ),
    );
  }

  // @pragma("vm:entry-point")

  void eventListnerCallback(BuildContext context) async {
    _checkDiff(DateTime _date) {
      var diff = DateTime.now().difference(_date).inHours;
      if (diff > 2) {
        return true;
      } else {
        return false;
      }
    }

    String _dateFormatter(String _timestamp) {
      String formattedDate =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
      return formattedDate;
    }

    _compareDate(String _date) {
      if (_dateFormatter(DateTime.now().toString())
              .compareTo(_dateFormatter(_date)) ==
          0) {
        return true;
      } else {
        return false;
      }
    }

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    final String? token = await FirebaseMessaging.instance.getToken();
    print("...token: $token....");
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bills')
        .orderBy('duedate')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print("... fcm listen element: $element...");

        _compareDate(element['duedate'].toDate().toString())
            ? http
                .post(Uri.http("192.168.137.1:8000", "/api/notifyapp"), body: {
                "title": "Android test title",
                "body":
                    "A reminder for payment to a bill for ${element['name']} due in 2 hours",
                "token": token,
              })
            : null;
      });
    });
  }
}

class NotificationController {
  /// this method is used to detect when a new notification or a schedule is created
  ///
  User? user;
  _checkDiff(DateTime _date) {
    var diff = DateTime.now().difference(_date).inHours;
    if (diff > 2) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> onActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    /// when notification is clicked
  }
}
