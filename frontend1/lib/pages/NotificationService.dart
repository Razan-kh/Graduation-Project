import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/UserNotification.dart';  // Import your notification screen
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class NotificationService {
  static String? _fcmToken;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize Firebase messaging and request permissions
  static Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getToken().then((token) {
      _fcmToken = token;
      print("FCM Token: $token");
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }

      // Simulate a click action manually when the notification is shown
      flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails()
          .then((details) {
        if (details?.didNotificationLaunchApp ?? false) {
          print("Notification clicked (foreground simulation)");
        //  _navigateToNotificationScreen(message);
        }
      });
    });

    // Handle notification taps (when app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked");
     _navigateToNotificationScreen(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.notification?.title}");
   // _navigateToNotificationScreen(message);
  }

  // Navigate to the notification screen
  static void _navigateToNotificationScreen(RemoteMessage message) async {
    String? jwtToken = await getToken();
    if (jwtToken != null) {
      if (navigatorKey.currentState?.canPop() ?? false) {
        navigatorKey.currentState?.pop(); // Pop any existing screens
      }

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificationsScreen(token: jwtToken),
        ),
      );
    }
  }

static Future<void> sendReminder( String title, String body) async {
  const String apiUrl = "http://$localhost/api/reminders"; // Replace with your API endpoint

  try {
    // Create the request body
    final Map<String, dynamic> requestBody = {
      "token": _fcmToken,
      "title": title,
      "body": body,
    };

    // Make the POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("Reminder sent successfully: ${responseData["messageId"]}");
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      print("Error: ${errorData["error"]}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}



  // Function to send message (notification) to the server
  static Future<void> sendMessage(BuildContext context, String title, String body, String recipient,
      String type, String token, [String projectID = '', Map<String, String> data = const {}]) async {
    final url = Uri.parse('http://$localhost/api/send-real-notification');
    print("Recipient id is $recipient");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'token': _fcmToken,
          'title': title,
          'body': body,
          'recepient': recipient,
          'type': type,
          if (projectID.isNotEmpty) 'projectID': projectID, // Only include if not empty
          if (data.isNotEmpty) 'data': data,
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
        /*
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent successfully')),
          
        );
        */
      } else {
        print('Failed to send message: ${response.body}');
        /*
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification')),
        );
        */
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending notification')),
      );
    }
  }
}

// Notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize notification channel
void initializeNotificationChannel() {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/logo'); // Ensure this drawable exists in your app

const InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
);

// Request notification permissions
void requestNotificationPermissions() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('User denied permission');
  } else {
    print('Permission status: ${settings.authorizationStatus}');
  }
}

// Function to retrieve JWT token from shared preferences
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}