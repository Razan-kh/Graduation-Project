import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/LocationNotifications/functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
import 'package:frontend1/pages/LocationNotifications/reminderNotification.dart';
import 'package:frontend1/pages/NotificationService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void startGeofencing( Reminder reminder) {
 StreamSubscription<Position>? positionSubscription;

  positionSubscription = Geolocator.getPositionStream().listen((Position position) {
      if (reminder.isTriggered) {
      // If already triggered, stop further processing
      positionSubscription?.cancel();
      positionSubscription = null;
      return;
    }
    // Check if the user's location is within a defined distance from the reminder location
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      reminder.location.latitude,
      reminder.location.longitude,
    );

    if (distance <= 1000) {  // 100 meters radius for geofencing
   positionSubscription?.cancel();
      positionSubscription = null;

      // Set reminder as triggered immediately to prevent duplicates
      reminder.isTriggered = true;

      print('User has arrived at the location!');
      Future.delayed(Duration(minutes: reminder.triggerAfterMinutes), () {
        // Trigger the reminder after the delay
        print('Reminder triggered: ${reminder.description}');
           positionSubscription?.cancel();
        positionSubscription = null;
        reminder.isTriggered=true;
       markReminderAsTriggered(reminder.id);
      NotificationService.sendReminder("Reminder", reminder.description);
        // Here you can use flutter_local_notifications to show a notification
      });
    
    }
  });

}


Future<void> markReminderAsTriggered( String reminderId) async {
    String? userId=await retrieveUserInfo();
    print(userId);
    print(reminderId);
  final String apiUrl = 'http://$localhost/api/reminders/$userId/$reminderId';

  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Reminder successfully triggered
      final responseData = jsonDecode(response.body);
      print('Reminder marked as triggered: ${responseData['message']}');
    } else if (response.statusCode == 400) {
      // Reminder already triggered
      print('Reminder already triggered.');
    } else if (response.statusCode == 404) {
      print('User or reminder not found.');
    } else {
      // Handle other status codes (server errors, etc.)
      print('Failed to trigger reminder. Server error.');
    }
  } catch (error) {
    // Handle error in HTTP request
    print('Error occurred while triggering reminder: $error');
  }
}
