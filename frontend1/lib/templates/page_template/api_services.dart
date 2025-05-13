import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchPage(String pageId, String token) async {
    print("Fetching page data for ID: $pageId");
    final response = await http.get(
      Uri.parse('$baseUrl/page/$pageId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load page');
    }
  }

  Future<Map<String, dynamic>> addWidget(
      String pageId, Map<String, dynamic> widgetData, String token) async {
    print("Adding widget to page: $pageId");
    print("Widget Data: $widgetData");

    final response = await http.post(
      Uri.parse('$baseUrl/page/$pageId/widgets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(widgetData),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      return json.decode(response.body); // Return the added widget data
    } else {
      throw Exception('Failed to add widget');
    }
  }

  Future<void> updateWidgetStyle(
      String pageId, String widgetId, Map<String, dynamic> styles, String token) async {
    print("Updating styles for widget: $widgetId on page: $pageId");
    print("Styles Data: $styles");

    final response = await http.put(
      Uri.parse('$baseUrl/page/$pageId/widgets/$widgetId/styles'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'styles': styles}),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update widget style');
    }
  }
}
