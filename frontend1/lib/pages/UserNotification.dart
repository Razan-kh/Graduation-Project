import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'NotificationModel.dart';

class NotificationsScreen extends StatefulWidget {
  final String token; // Authorization token for API requests

  const NotificationsScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
    _notificationsFuture = NotificationService.getNotifications(widget.token);
  }

  Future<void> toggleReadState(String id) async {
    final response = await http.put(
      Uri.parse('http://$localhost/api/Notifications/$id/toggle-read'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle read state');
    }
  }

  Future<void> deleteNotification(String id) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/Notifications/$id'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }

    setState(() {
      _notificationsFuture = NotificationService.getNotifications(widget.token);
    });
  }

  Future<void> clearAllNotifications() async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/Notifications/clear-all'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear all notifications');
    }

    setState(() {
      _notificationsFuture = NotificationService.getNotifications(widget.token);
    });
  }

  Future<bool> updateNotificationStatus(String id, String status) async {
    final url = 'http://$localhost/api/Notifications/$id/status';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<void> acceptInvitation(String templateId) async {
    final url = Uri.parse('http://$localhost/api/add-template/$templateId');
    final body = json.encode({'title': 'project', 'role': 'editor'});
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept invitation');
    }
  }

  String getSenderName(String senderId) {
    if (senderId == null) {
      return "Unknown Sender";
    }

    final user = users.firstWhere(
      (user) => user['_id'] == senderId,
      orElse: () => {},
    );
    List<String> parts = user['email'].split('@');
    return user.isNotEmpty ? parts[0] ?? "" : "";
  }

  Future<void> _fetchAllUsers() async {
    final url = Uri.parse('http://$localhost/Users');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map((user) => user as Map<String, dynamic>).toList();
        });
      } else {
        print('Failed to fetch users');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Notifications',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            tooltip: 'Clear All Notifications',
            onPressed: () async {
              await clearAllNotifications();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No notifications found.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final sender = getSenderName(notification.senderId!);
                String sentence = notification.type == "invitation"
                    ? "invited you to a project"
                    : "mentioned you in a project";

                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await deleteNotification(notification.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification deleted')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      title: Text(
                        "$sender $sentence",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '${notification.createdAt.toLocal()}'.split('.')[0],
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: notification.type == "invitation"
                          ? _invitationActions(notification)
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: _footer(),
    );
  }

  Widget _invitationActions(NotificationModel notification) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (notification.type == "invitation") ...[
          if (notification.status == "pending") ...[
            GestureDetector(
              onTap: () async {
                await acceptInvitation(notification.project!);
                await updateNotificationStatus(notification.id, "accepted");
                setState(() {
                  notification.data?["status"] = "accepted";
                });
              },
              child: Container(
                width: 60,
                height: 50,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Accept',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await updateNotificationStatus(notification.id, "rejected");
                setState(() {
                  notification.data?["status"] = "rejected";
                });
              },
              child: Text("Reject", style: TextStyle(color: Colors.red)),
            ),
          ]
        ],
        if (notification.data?["status"] == "accepted")
          const Text('Accepted', style: TextStyle(color: Colors.blue, fontSize: 14)),
        if (notification.data?["status"] == "rejected")
          const Text('Declined', style: TextStyle(color: Colors.red, fontSize: 14)),
      ],
    );
  }
 Widget _footer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.grey, size: 28),
          Icon(Icons.search, color: Colors.grey, size: 28),
          Icon(Icons.folder, color: Colors.blue, size: 28),
          Icon(Icons.edit, color: Colors.grey, size: 28),
        ],
      ),
    );
  }
}