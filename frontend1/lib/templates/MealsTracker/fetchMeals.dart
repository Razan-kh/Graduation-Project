import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {
  final String appId = 'effb73eb';
  final String appKey = '66d0f81a7ef21adab7d9d0d01e305f6b';

  Future<List<dynamic>> fetchRecipes(String query) async {
    final url = Uri.parse(
        'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=$appId&app_key=$appKey&from=0&to=100');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hits']; // Each hit contains a recipe
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
