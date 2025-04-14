import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../Network/local_db/share_preference.dart';

class NotificationHelper {
  static String pushToken = CashSaver.getData(key: 'Token') ?? '';
  static String accessToken = CashSaver.getData(key: 'AccessToken') ?? '';
  static DateTime? tokenExpiry = DateTime.tryParse(CashSaver.getData(key: 'AccessTokenExpiry') ?? '');

  // Firebase Messaging instance
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> checkSubscriptionStatus() async {
    bool? subscribed = CashSaver.getData(key: 'isSubscribed');

    if (subscribed == null || !subscribed) {
      // Not subscribed, subscribe now
      await fMessaging.subscribeToTopic('all_users');
      CashSaver.saveData(key: 'isSubscribed', value: true);
    }
  }

  static Future<void> checkSubscriptionStatus_Admin() async {
    bool? subscribed = CashSaver.getData(key: 'isSubscribed');
    if (subscribed == null || !subscribed) {
      // Not subscribed, subscribe now
      await fMessaging.subscribeToTopic('admin');
      CashSaver.saveData(key: 'isSubscribed', value: true);
    }
  }

  // Method to send notifications to a topic
  static Future<void> sendNotificationToAllUsers({
    required String title,
    required String body,
    required String topic,
    String? mediaUrl,
  }) async {
    if (accessToken.isEmpty || _isTokenExpired()) {
      accessToken = await getAccessToken() ?? '';
    }

    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/id_name/messages:send');

    // Build the message payload
    final message = {
      "message": {
        "topic": topic,
        "notification": {
          "title": title,
          "body": body,
          if (mediaUrl != null) "image": mediaUrl,
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message), // Use jsonEncode to convert the message to JSON string
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully to topic: $topic');
      } else {
        log('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }


  // Method to get the Firebase Messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        pushToken = t;
        CashSaver.saveData(key: 'Token', value: pushToken);
        log('Push Token: $t');
      }
    });
  }

  // Method to send notifications using OAuth2 and FCM
  static Future<void> sendNotification({
    required String title,
    required String body,
    required String targetToken,
    String? mediaUrl,
  }) async {
    if (accessToken.isEmpty || _isTokenExpired()) {
      accessToken = await getAccessToken() ?? '';
    }

    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/id_name/messages:send');

    // Build the message payload
    final message = {
      "message": {
        "token": targetToken,
        "notification": {
          "title": title,
          "body": body,
          if (mediaUrl != null) "image": mediaUrl,
        },
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message), // Use jsonEncode to convert the message to JSON string
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully');
      } else {
        log('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }


  // Method to get OAuth2 access token and save its expiry time
  static Future<String?> getAccessToken() async {
    final serviceAccountJson = {
/// todo :: json key
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      var client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      var credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      client.close();
      accessToken = credentials.accessToken.data;
      tokenExpiry = DateTime.now().add(Duration(seconds: credentials.accessToken.expiry.year));

      // Save the access token and expiry in shared preferences
      CashSaver.saveData(key: 'AccessToken', value: accessToken);
      log("Access Token: $accessToken");


      return accessToken;
    } catch (e) {
      log("Error getting access token: $e");
      return null;
    }
  }

  // Method to check if the token has expired
  static bool _isTokenExpired() {
    if (tokenExpiry == null) return true;
    return DateTime.now().isAfter(tokenExpiry!);
  }
}
