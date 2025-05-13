import 'dart:convert';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/LocationNotifications/functions.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final String id;
  final String type;
  final String recipient;
  final String? project;
   Map<String, dynamic>? data;
  final DateTime createdAt;
   bool read;
 String ?senderId;
  NotificationModel({

    required this.id,
    required this.type,
    required this.recipient,
    this.project,
    this.data,
    required this.createdAt,
    required this.read,
     this.senderId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(

      id: json['_id'],
      type: json['type'],
      recipient: json['recipient'],
      project: json['project'],
      data: json['data'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'],
      senderId: json['sender'],
    );
    
  }

  // Getter for the 'status' field inside 'data' if the type is 'invitation'
  String? get status {
    if (type == "invitation" && data != null) {
      return data?["status"];
    }
    return null; // Return null if not an invitation or no status field
  }

}


class NotificationService {
  static const String baseUrl = 'http://$localhost/api/Notifications';
static int unreadMessages=0;
  static Future<List<NotificationModel>> getNotifications(String token) async {
    final url = Uri.parse('$baseUrl');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }
  

  
 static Future<void> markNotificationsAsRead() async {
String? token=await retrieveUserToken();
  final url = Uri.parse('http://$localhost/api/notifications/mark-Allread');

  try {
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'status': 'read', // You can send a status to mark notifications as read
      }),
    );

    if (response.statusCode == 200) {
      print("all notifications are marked as read");
      // Successfully updated the notifications to "read"
      unreadMessages=0;
    } else {
      print('Failed to mark notifications as read');
    }
  } catch (error) {
    print('Error: $error');
  }
}

 static Future<String?> retrieveUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String? token = prefs.getString('token');

    if (token != null) {
    return token;
    }
  }

/*
static Future<void> fetchUnreadNotificationCount() async {
  String ?token=await retrieveUserToken();
  final url = Uri.parse('http://$localhost/api/unread-count');  // Update the URL

  try {
    // Send GET request to the backend API with the token in the Authorization header
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',  // Include the token in the header for authentication
      },
    );

    // Check if the response status is OK
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      unreadMessages=data['unreadCount'];
      print("unread messages is ${unreadMessages}");
      }
       
     else {
      throw Exception('Failed to load unread notifications');
    }
  } catch (error) {
    print('Error fetching unread notification count: $error');
   
  }
}
*/
}