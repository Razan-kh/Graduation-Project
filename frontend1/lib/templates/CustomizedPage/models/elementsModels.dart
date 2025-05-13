import 'dart:ui';
import 'package:frontend1/templates/CustomizedPage/models/elemntModel.dart';

class TableElementModel extends ElementModel {
  List<List<String>> rows;
  List<Map<String, dynamic>> columns;
  Map<int, Color> rowColors; // Stores custom row colors
  Color? headerColor; // Stores the header color
  TableElementModel({
    required super.position,
    required super.size,
      required String id,
    required this.rows,
    required this.columns,
      this.rowColors = const {}, // Default empty map
    this.headerColor, // Nullable header color
  }) : super(type: 'table', content:  {
            'rows': rows,
            'columns': columns,
             'rowColors': rowColors.map((key, value) => MapEntry(key.toString(), value.value)),
            'headerColor': headerColor?.value,
          },);
/*
  factory TableElementModel.fromJson(Map<String, dynamic> json) {
    return TableElementModel(
       position: Offset(
      (json['position']['x'] as num).toDouble(), // Convert to double
      (json['position']['y'] as num).toDouble(), // Convert to double
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(), // Convert to double
      (json['size']['height'] as num).toDouble(), // Convert to double
    ),
      id:json['_id'],
   
      rows: List<List<String>>.from(
        (json['content']['rows'] as List).map(
          (row) => List<String>.from(row),
        ),
      ),
      columns: List<Map<String, dynamic>>.from(json['content']['columns']),
       rowColors: (json['content']['rowColors'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(int.parse(key), Color(value))) ??
          {},
      headerColor: json['content']['headerColor'] != null
          ? Color(json['content']['headerColor'])
          : null,
    );
  }
*/
factory TableElementModel.fromJson(Map<String, dynamic> json) {
   var columns = List<Map<String, dynamic>>.from(json['content']['columns']);

    // Iterating through columns and checking for 'options' type
    for (var column in columns) {
      if (column['type'] == 'options' && column['options'] != null) {
        // Convert options from List<dynamic> to List<String>
        column['options'] = List<String>.from(column['options']);
      }
    }
  return TableElementModel(
    position: Offset(
      (json['position']['x'] as num).toDouble(),
      (json['position']['y'] as num).toDouble(),
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(),
      (json['size']['height'] as num).toDouble(),
    ),
    id: json['_id'],
    rows: List<List<String>>.from(
      (json['content']['rows'] as List).map(
        (row) => List<String>.from(row),
      ),
    ),
   // columns: List<Map<String, dynamic>>.from(json['content']['columns']),
columns: columns,
    
    rowColors: (json['content']['rowColors'] as Map<String, dynamic>?)
        ?.map((key, value) {
          // Convert the int value to Color
          return MapEntry(int.parse(key), Color(value));
        }) ?? {},
    headerColor: json['content']['headerColor'] != null
        ? Color(json['content']['headerColor'])
        : null, // Convert headerColor from int to Color
  );
}


  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'content': {
        'rows': rows,
        'columns': columns,
        'rowColors': rowColors.map((key, value) => MapEntry(key.toString(), value.value)),
        'headerColor': headerColor?.value,
      },
    };
  }
}
class TextElementModel extends ElementModel {
  String text;
  double fontSize;
  Color fontColor;

  TextElementModel({
    required super.position,
    required super.size,
     required String id,
    required this.text,
    required this.fontSize,
    required this.fontColor,
  }) : super(type: 'text', content: {
            'text': text,
            'fontSize': fontSize,
            'fontColor': fontColor.value,
          },);

  factory TextElementModel.fromJson(Map<String, dynamic> json) {
    return TextElementModel(
      position: Offset(
      (json['position']['x'] as num).toDouble(), // Convert to double
      (json['position']['y'] as num).toDouble(), // Convert to double
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(), // Convert to double
      (json['size']['height'] as num).toDouble(), // Convert to double
    ),
      text: json['content']['text'],
      fontSize: (json['content']['fontSize']as num).toDouble(),
      id:json['_id'],
      fontColor: Color(json['content']['fontColor'])
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'content': {
        'text': text,
        'fontSize': fontSize,
        'fontColor': fontColor.value,
      },
    };
  }
}

class ImageElementModel extends ElementModel {
  String ?url;

  ImageElementModel({
    required super.position,
    required super.size,
   //  required String id,
    required this.url,

  }) : super(type: 'image', content: {
    'url':url
  });

  factory ImageElementModel.fromJson(Map<String, dynamic> json) {
   return ImageElementModel(
    position: Offset(
      (json['position']['x'] as num).toDouble(), // Convert to double
      (json['position']['y'] as num).toDouble(), // Convert to double
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(), // Convert to double
      (json['size']['height'] as num).toDouble(), // Convert to double
    ),
    url: json['content']['url'],
  //  id: json['_id'],
  );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'content': {
        'url': url,
       
      },
    };
  }
}

class BulletElementModel extends ElementModel {
  final List<String> tasks;
  double fontSize;
  Color fontColor;

  BulletElementModel({
    required super.position,
    required super.size,
     required String id,
    required this.tasks,
    required this.fontSize,
    required this.fontColor,
  }) : super(type: 'bullet', content: {
            'tasks': tasks,
            'fontSize': fontSize,
            'fontColor': fontColor.value,
          },);

  factory BulletElementModel.fromJson(Map<String, dynamic> json) {
      List<String> tasks = (json['content']?['tasks'] as List<dynamic>?)
      ?.map((task) => task.toString().replaceFirst(RegExp(r'^\d+\.\s*'), ''))
      .toList() ??
      [];
    return BulletElementModel(
      position: Offset(
      (json['position']['x'] as num).toDouble(), // Convert to double
      (json['position']['y'] as num).toDouble(), // Convert to double
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(), // Convert to double
      (json['size']['height'] as num).toDouble(), // Convert to double
    ),
  // tasks: (json['content']['tasks'] as List?)?.map((task) => task.toString()).toList() ?? [], // Fallback to empty list
  tasks:tasks,
      fontSize: (json['content']['fontSize']as num).toDouble(),
      id:json['_id'],
      fontColor: Color(json['content']['fontColor'])
    );
  }

  @override
   /// Converts the `BulletElementModel` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'position': {
        'x': position.dx,
        'y': position.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'content': {
        'tasks': tasks,
        'fontSize': fontSize,
        'fontColor': fontColor.value,
      },
   
    };
  }
}

class ToDoElementModel extends ElementModel {
  final  List<Map<String, dynamic>> tasks;


  ToDoElementModel({
    required super.position,
    required super.size,
     required String id,
    required this.tasks,

  }) : super(type: 'todo', content: {
            'tasks': tasks,
          },);

  factory ToDoElementModel.fromJson(Map<String, dynamic> json) {
    // Initialize tasks as an empty list by default
    List<Map<String, dynamic>> tasks = [];

    // Safely parse tasks if present
    final dynamic rawTasks = json['content']?['tasks'];

    if (rawTasks is Map<String, dynamic>) {
      // Handle case where tasks are stored with numbered keys
      tasks = rawTasks.entries
          .map((entry) => Map<String, dynamic>.from(entry.value))
          .toList();
    } else if (rawTasks is List<dynamic>) {
      // Handle fallback case where tasks are a list
      tasks = rawTasks
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    return ToDoElementModel(
      position: Offset(
        (json['position']['x'] as num).toDouble(), // Convert x to double
        (json['position']['y'] as num).toDouble(), // Convert y to double
      ),
      size: Size(
        (json['size']['width'] as num).toDouble(), // Convert width to double
        (json['size']['height'] as num).toDouble(), // Convert height to double
      ),
      id: json['_id'] as String, // Retrieve id as String
      tasks: tasks, // Assign parsed tasks
    );
  }

  @override
  /// Converts the `ToDoElementModel` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'position': {
        'x': position.dx,
        'y': position.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'content': {
        'tasks': tasks, // Serialize tasks as is
      },
    };
  }
}class CalenderElementModel extends ElementModel {
  // Map<DateTime, String> to store events
  Map<DateTime, String> events;

  CalenderElementModel({
    required super.position,
    required super.size,
    required String id,
    required Map<dynamic, dynamic> events, // Accept dynamic map for flexibility
  })  : events = _parseEvents(events), // Convert events to Map<DateTime, String>
        super(
          type: 'calendar',
          content: {
            'events': events.map((key, value) =>
                MapEntry(key.toString(), value.toString())), // For JSON compatibility
          },
        );

  // Helper function to parse events into Map<DateTime, String>
  static Map<DateTime, String> _parseEvents(Map<dynamic, dynamic> rawEvents) {
    final parsedEvents = <DateTime, String>{};
    rawEvents.forEach((key, value) {
      final dateKey = DateTime.tryParse(key.toString());
      if (dateKey != null && value is String) {
        parsedEvents[dateKey] = value;
      }
    });
    return parsedEvents;
  }

  // Factory constructor to create an instance from JSON
factory CalenderElementModel.fromJson(Map<String, dynamic> json) {
  return CalenderElementModel(
    position: Offset(
      (json['position']['x'] as num).toDouble(),
      (json['position']['y'] as num).toDouble(),
    ),
    size: Size(
      (json['size']['width'] as num).toDouble(),
      (json['size']['height'] as num).toDouble(),
    ),
    id: json['_id'].toString(), // Convert ObjectId to string
    events: (json['content']?['events'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(
            DateTime.parse(key), // Convert String key to DateTime
            value.toString(),    // Ensure the value is a String
          ),
        ) ??
        {}, // Default to an empty map if 'events' is null
  );
}



  // Serialize the model to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'position': {
        'x': position.dx,
        'y': position.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'content': {
        'events': events.map((key, value) =>
            MapEntry(key.toIso8601String(), value)), // Convert DateTime to String
      },
    };
  }
}