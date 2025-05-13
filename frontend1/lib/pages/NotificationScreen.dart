/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
  }

  // Initialize Firebase Messaging
  void initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();

    // Retrieve the FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _fcmToken = token;
      });
      print("FCM Token: $token");
      // Send this token to your server if necessary
    });
  
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? "Notification"),
          content: Text(message.notification?.body ?? ""),
        ),
      );
    });


    // Handle when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked!");
    });
    
  }

  // Function to send a notification via backend
  Future<void> sendMessage(String token, String title, String body) async {
    final url = Uri.parse('http://$localhost/api/send-real-notification');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent successfully')),
        );
      } else {
        print('Failed to send message: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification')),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending notification')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Push Notifications')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for notifications...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (_fcmToken != null)
              ElevatedButton(
                onPressed: () {
                  // Replace these with real values for testing
                  sendMessage(_fcmToken!, 'Test Notification', 'This is a test message.');
                },
                child: Text('Send Test Notification'),
              ),
            if (_fcmToken == null)
              Text('Fetching FCM Token...'),
          ],
        ),
      ),
    );
  }
}


// Notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.notification?.title}");
}

// Initialize notification channel
void initializeNotificationChannel() {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
  // Description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Request notification permissions
void initializeFirebaseMessaging() async {
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
*/