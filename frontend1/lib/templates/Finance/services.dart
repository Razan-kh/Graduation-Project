import 'dart:convert';
import 'package:frontend1/templates/Finance/classes/finance.dart';
import 'package:http/http.dart' as http;

Future<List<Finance>> fetchFinances() async {
  final response = await http.get(Uri.parse('http://localhost:5000/api/finances'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Finance.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load finances');
  }
}