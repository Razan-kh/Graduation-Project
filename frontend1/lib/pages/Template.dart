import 'dart:convert';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;

class Template {
  final String? id;
  final String? userId;
  final String? title;
  final String? type;
  final String? data;
  final DateTime? createdAt;

  Template({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.data,
    required this.createdAt,
  });

  // Factory method to create a Template instance from JSON
  factory Template.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] as String?;
    final userId = json['userId'] is Map<String, dynamic> ? json['userId']['_id'] as String? : json['userId'] as String?;
    final data = json['data'] is Map<String, dynamic> ? json['data']['_id'] as String? : json['data'] as String?;

    return Template(
      id: id,
      userId: userId,
      title: json['title'] as String?,
      type: json['type'] as String?,
      data: data,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  // Static method to fetch template data
  static Future<Template?> fetchTemplateData(String templateId, String token) async {
    print(templateId);
    final url = 'http://$localhost/api/getTemplateInfo/$templateId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
      //  print("status code is 200");
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('Response JSON: $json');
        
        // Return the parsed Template object
        return Template.fromJson(json);
      } else {
        print('Failed to fetch template data: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching template data: $error');
      return null;
    }
  }

 static Future<Template?> createTemplate(
         String token,
     String type,
     String title,
    String data ,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("http://$localhost/api/template"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add Authorization header with the token
        },
        body: jsonEncode({
          'type': type,
          'title': title,
          'data': data,
        }),
      );

      if (response.statusCode == 201) {
        // If the server responds with 201, it means the template was created successfully
        print('Template created successfully');
        final responseBody = jsonDecode(response.body);
        print('Template ID: ${responseBody['template']['_id']}');
        //Template t=responseBody['template'];
        return Template.fromJson(responseBody['template']);
        
        // Optionally, you can handle the template object here
      } else {
        // Handle errors (non-201 status codes)
        print('Failed to create template: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['error']}');
        return null;
      }
    } catch (e) {
      // Catch any errors during the request
      print('Error creating template: $e');
      return null;
    }
  }
}
