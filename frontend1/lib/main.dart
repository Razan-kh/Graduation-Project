import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend1/pages/NotificationService.dart';
import 'package:frontend1/templates/AssignmentTracker/CoursesModel.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/color.dart';
import 'package:frontend1/templates/CustomizedPage/models/pageModel.dart';
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/Finance/python.dart';
import 'package:frontend1/templates/Finance/chart1.dart';
import 'package:frontend1/templates/Finance/chart2.dart';




/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
*/
void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Ensure this drawable exists

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize Firebase messaging and local notifications
  NotificationService.initializeFirebaseMessaging();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Set up background message handler for Firebase messaging
  initializeNotificationChannel();
*/

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NutritionalDataNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BackgroundColorNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NotificationService.navigatorKey,
        home: const LoginPage(),
      // home:FinanceForecastPage()
       //   home: FinancialChartPage(),
      // home:NetIncomeChart()

      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationService.navigatorKey,
      // title: 'Flutter app',
      home: LoginPage(),
    );
  }
}