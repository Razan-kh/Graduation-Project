import 'dart:ui';

import 'package:frontend1/templates/CustomizedPage/models/elementsModels.dart';

class ElementModel {
  String type; // 'table', 'text', 'image', etc.
  //  String id;
  Offset position;
  Size size;
  dynamic content; // Flexible content type for specific elements

  ElementModel({
    required this.type,
  //    required this.id,
    required this.position,
    required this.size,
    required this.content,
  });

  factory ElementModel.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'table':
        return TableElementModel.fromJson(json);
      case 'text':
        return TextElementModel.fromJson(json);
      case 'image':
        return ImageElementModel.fromJson(json);
        case 'bullet':
        return BulletElementModel.fromJson(json);
        case 'todo':
        return ToDoElementModel.fromJson(json);
         case 'calendar':
        return CalenderElementModel.fromJson(json);
      // Add other cases here
      default:
        throw Exception("Unknown element type: ${json['type']}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'position': {'x': position.dx, 'y': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'content': content,
    };
  }
}
