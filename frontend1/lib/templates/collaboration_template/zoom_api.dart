import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ZoomMeetingPage extends StatelessWidget {
  const ZoomMeetingPage({super.key});

  // Function to create a Zoom meeting by calling the backend and then launching the URL
  Future<void> createAndLaunchZoomMeeting() async {
    try {
      // Call your backend API to create a Zoom meeting and get the URL
      final response = await http.post(
        Uri.parse('http://$localhost/api/zoom/create'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'topic': 'Flutter Test Meeting',
          'start_time': DateTime.now().add(Duration(minutes: 10)).toIso8601String(),
          'duration': 30, // Meeting duration in minutes
        }),
      );

      // Check if the response was successful
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String meetingUrl = responseData['meeting_url'];
        print('Meeting URL from backend: $meetingUrl');

        // Encode and parse the URL to make it safe
        Uri uri = Uri.parse(Uri.encodeFull(meetingUrl));

        // Launch the meeting URL
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $meetingUrl');
        }
      } else {
        print('Failed to create meeting: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Meeting Launcher'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: createAndLaunchZoomMeeting,
          child: const Text('Create and Join Zoom Meeting'),
        ),
      ),
    );
  }
}
