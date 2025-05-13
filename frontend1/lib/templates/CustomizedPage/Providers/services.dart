import 'dart:convert';
import 'dart:ui';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
 // print("token is $token");
  return token;
}

Future<void> updateElementContent({
  required String pageId,
  required int elementIndex,
  required Map<String,dynamic> newContent,
   

}) async {
  print("$pageId  $elementIndex  $newContent");

    // Convert Color values to int
  if (newContent.containsKey('rowColors')) {
    newContent['rowColors'] = newContent['rowColors'].map((key, value) {
      return MapEntry(key.toString(), (value as Color).value.toDouble());  // Convert Color to int
    });
  }

  if (newContent.containsKey('headerColor') && newContent['headerColor'] is Color) {
    newContent['headerColor'] = (newContent['headerColor'] as Color).value.toDouble();  // Convert Color to int
  }

  
    String? token = await getToken();
  final url = Uri.parse('http://$localhost/api/pages/$pageId/elements/$elementIndex');
  final headers = {'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
  };
  final body = jsonEncode({'newContent': newContent});

  try {
    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Content updated successfully: ${response.body}');
    } else {
      print('Failed to update content. Status code: ${response.statusCode}');
    //  print('Response: ${response.body}');
    }
  } catch (error) {
    print('Error updating content: $error');
  }
}
