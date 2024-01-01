import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class Notifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {}
  }

  static Future<dynamic> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<bool> sendNotification(
      String title, String body, List<String> tokens) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": tokens,
      "notification": {
        "title": title,
        "body": body,
        "sound": "default",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=<KEY>',
    };

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Sent Hooray!");
        return true;
      } else {
        print('FCM request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending FCM message: $e');
      return false;
    }
  }
}
