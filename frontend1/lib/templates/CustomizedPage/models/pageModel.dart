import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/models/elementsModels.dart';
import 'package:http/http.dart' as http;
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/CustomizedPage/models/elemntModel.dart';

class PageModel {
  String id;
  String title;
  Color BackgroundColor;
   Color appBarColor;
  String icon;
  List<ElementModel> elements;
  Color toolBarColor;

  PageModel({
    required this.id,
    required this.title,
    required this.elements,
    required this.BackgroundColor,
    required this.appBarColor,
    required this.icon,
    required this.toolBarColor,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['_id'],
      title: json['title'],
      BackgroundColor: Color(json['BackgroundColor']),
      appBarColor: Color(json['appBarColor']),
      toolBarColor: Color(json['toolBarColor']),
      icon: json['icon'],
      elements: (json['elements'] as List)
          .map((e) => ElementModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'elements': elements.map((e) => e.toJson()).toList(),
    };
  }
}
/*
Future<PageModel> fetchPage(String pageId) async {
  final response = await http.get(Uri.parse('http://$localhost/api/customPage/$pageId'));
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return PageModel.fromJson(data);
  } else {
    throw Exception('Failed to load page');
  }
}
*/

class PageProvider with ChangeNotifier {
  PageModel? _page;
  bool _isLoading = false;
  String? _error;

  PageModel? get page => _page;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch page data from the API
  Future<void> fetchPage(String pageId) async {
    _isLoading = true;
    _error = null;
    //notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://$localhost/api/customPage/$pageId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print("page is fetched successfully");
        _page = PageModel.fromJson(data);
      //  print(_page);
      } else {
        _error = 'Failed to load page';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


 Future<void> updateImageElement(int index, ImageElementModel imageElement) async {
  try {
    // First, check if the index is valid
    if (_page == null || _page!.elements.isEmpty || index < 0 || index >= _page!.elements.length) {
      throw Exception('Invalid index');
    }

    // Update the image element at the given index
    _page!.elements[index] = imageElement;

    // Optionally, you can also call a backend API to update the image element
    // await pageService.updateImageElement(imageElement);

    // Notify listeners to update the UI
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  }
}

  void updateElementSize(int index, double newWidth, double newHeight) {
    page!.elements[index].size = Size(newWidth, newHeight);
    notifyListeners(); // Notify listeners to update UI
  }


}