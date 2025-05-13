import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000"; // Change this to your backend URL

  // University APIs
  static Future<List<dynamic>> getUniversities() async {
    final response = await http.get(Uri.parse("$baseUrl/universities"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load universities");
    }
  }

  static Future<void> addUniversity(Map<String, dynamic> universityData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/universities"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(universityData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add university");
    }
  }

  static Future<void> updateUniversity(String id, Map<String, dynamic> universityData) async {
    final response = await http.put(
      Uri.parse("$baseUrl/universities/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(universityData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update university");
    }
  }

  static Future<void> deleteUniversity(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/universities/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete university");
    }
  }

  // Task APIs
  static Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/tasks"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  static Future<void> addTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tasks"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add task");
    }
  }

  static Future<void> updateTask(String id, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(taskData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }

  static Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/tasks/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
