// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';




class TaskService {


  Future<List<dynamic>> fetchTasks() async {
    final response = await http.get(Uri.parse('http://$localhost/api/tasks'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('http://$localhost/api/tasks'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }
}


class ApiService {
  final String token;

  ApiService(this.token);

  // Base URL of the backend server
  final String baseUrl = 'http://$localhost/api'; // Replace with your backend URL

  // Fetch whiteboard data for a specific template
  Future<List<dynamic>> getWhiteboardData(String templateId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/template/$templateId/whiteboard'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Parse JSON response
    } else {
      throw Exception('Failed to fetch whiteboard data');
    }
  }

  // Save whiteboard data to the backend
  Future<void> saveWhiteboardData(String templateId, List<dynamic> whiteboardData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/template/$templateId/whiteboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'whiteboardData': whiteboardData}), // Send whiteboard data as JSON
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save whiteboard data');
    }
  }
}