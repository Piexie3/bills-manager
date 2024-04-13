import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_and_doctor_appointment/constants.dart';
import 'package:health_and_doctor_appointment/firebase_options.dart';
import 'package:http/http.dart' as http;

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
        // icon: "assets/ic_launcher.png",
      ),
    );
  }

  // Future<void> sendPushNotification({
  //   required String deviceToken,
  //   required String body,
  //   required String title,
  // }) async {
  //   try {
  //     http.Response response = await http
  //         .post(Uri.parse('https://fcm.googleapis.com/messages/send'), body: {
  //       "title": "NOTI title",
  //       "body": "",
  //       "key": "hjsdcsjs bccxbbbhbkjz"
  //     });
  //     print("response = ${response.body}");
  //   } catch (e) {
  //     print('error: ' + e.toString());
  //   }
  // }

  void eventListnerCallback(BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    final String? token = await FirebaseMessaging.instance.getToken();
    print("...token: $token....");

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bills')
        .where("paid", isEqualTo: false)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) async {
        print("... fcm listen element: $element...");

        // Calculate 1 day before due date
        _checkDiff(DateTime _date) {
          var diff = _date.difference(DateTime.now()).inHours;
          print("time diff: $diff");
          if (diff == 24) {
            return true;
          } else {
            return false;
          }
        }

        // Check if current date is the calculated one day before du e date
        if (_checkDiff(element['duedate'].toDate())) {
          createOrderNotifications(
            body:
                "A reminder for payment to a bill for ${element['name']} due in 1 Day",
            title: "Bills Reminder",
          );
        }
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
    if (diff == 24) {
      return 24;
    } else {
      return;
    }
  }

  static Future<void> onActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    /// when notification is clicked
  }
}



// _checkDiff(DateTime _date) {
//   var diff = DateTime.now().difference(_date).inHours;
//   if (diff == 24) {
//     return 24;
//   } else {
//     return;
//   }
// }
