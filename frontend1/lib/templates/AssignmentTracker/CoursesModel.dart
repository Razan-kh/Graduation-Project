// // Model for Course
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// import 'package:frontend1/pages/Template.dart';

// class Course {
//   final String name;
//   final int mark;
//   final String icon;
//   final List<Assignment> assignments; // Change to Assignment model
//   final String id;

//   Course({
//     required this.name,
//     required this.mark,
//     required this.icon,
//     required this.assignments,
//     required this.id,
//   });

//   factory Course.fromJson(
//       Map<String, dynamic> json, List<Assignment> allAssignments) {
//     // Map assignment IDs to Assignment objects
//     List<Assignment> courseAssignments =
//         json['assignments'].map<Assignment>((id) {
//       return allAssignments.firstWhere((assignment) => assignment.id == id,
//           orElse: () => Assignment(id: id, assignmentName: '', values: []));
//     }).toList();

//     return Course(
//       name: json['name'],
//       mark: json['mark'],
//       icon: json['icon'],
//       assignments: courseAssignments,
//       id: json['_id'],
//     );
//   }
// }

// // Model for Assignment
// class Assignment {
//   final String? id; // ID for the assignment
//   String assignmentName; // Matches the actual response key
//   List<dynamic>? values;

//   Assignment({
//     required this.id,
//     required this.assignmentName,
//     required this.values,
//   });

//   factory Assignment.fromJson(Map<String, dynamic> json) {
//     return Assignment(
//       id: json['_id'] as String?,
//       assignmentName: json['assignmentName'] as String,
//       values:
//           json['values'] != null ? List<dynamic>.from(json['values']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'assignmentName': assignmentName,
//       'values': values,
//     };
//   }
// }

// class CourseProvider extends ChangeNotifier {
//   List<Course> _courses = [];
//   List<Assignment> _allAssignments = [];
//   // Getter for courses
//   List<Course> get courses => _courses;
//   set courses(List<Course> courses) {
//     _courses = courses;
//     notifyListeners(); // Notify listeners when courses are updated
//   }

//   // Getter for assignments
//   List<Assignment> get allAssignments => _allAssignments;

//   // Setter for assignments
//   set allAssignments(List<Assignment> assignments) {
//     _allAssignments = assignments;
//     notifyListeners(); // Notify listeners when assignments are updated
//   }

//   // Method to fetch courses and store them in _courses list

//   Future<void> fetchCourses(String templateId, String token) async {
//     try {
//       var template = await Template.fetchTemplateData(templateId, token);
//       print('Fetched Template Data: ${template?.data}');

//       // Fetch assignments by template ID
//       final assignmentResponse = await http.get(
//         Uri.parse('http://$localhost/api/fetchAssignments'),
//         headers: {
//           'Authorization': 'Bearer ${token}',
//           'Content-Type': 'application/json',
//         },
//       );

//       // Print the response body for debugging
//       print('Assignments response body: ${assignmentResponse.body}');

//       if (assignmentResponse.statusCode == 200) {
//         // Decode the JSON response for assignments
//         List<dynamic> assignmentData = json.decode(assignmentResponse.body);
//         _allAssignments = assignmentData
//             .map((assignmentJson) => Assignment.fromJson(assignmentJson))
//             .toList();

//         // Now fetch courses
//         final courseResponse = await http.get(
//           Uri.parse('http://$localhost/api/fetchCourses/${template?.data}'),
//           headers: {
//             'Authorization': 'Bearer ${token}',
//             'Content-Type': 'application/json',
//           },
//         );

//         if (courseResponse.statusCode == 200) {
//           // Decode the JSON response for courses
//           List<dynamic> courseData = json.decode(courseResponse.body);

//           // Ensure courseData is a list and map to Course objects
//           List<Course> data = courseData
//               .map((item) => Course.fromJson(item, _allAssignments))
//               .toList();
// /*
//           setState(() {
//             courses = data;
//           });
// */
//           courses = data;

//           print("Courses data: ${data[0]}");
//                 } else {
//           throw Exception(
//               'Failed to load courses: ${courseResponse.statusCode}');
//         }
//       } else {
//         throw Exception(
//             'Failed to load assignments: ${assignmentResponse.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching courses: $e');
//     }
//   }

// /*
//   Future<void> AddCourse( String newCourseName,String token,String templateId) async {
//   var  template = await Template.fetchTemplateData(templateId, token);
//   final String url = 'http://$localhost/api/Add_Course/${template?.data}'; // Replace with your actual API endpoint

//   // Prepare the data to be sent to the API
 
// print("token is ${token}");
//   try {
    
//     // Make the PATCH request to your API
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${token}', // Add your token if needed
//       },
//       body: json.encode({"name":newCourseName}),
//     );

//     // Check the response status
//     if (response.statusCode == 201) {
//       // Successfully updated the assignment name
//       final data = json.decode(response.body);
//      final newCourse=data['data'];
//       print('Course created: $newCourse');
//     /*  setState(() {
//             courses.add(newCourse);
//       });*/
//      // final course0 = Course.fromJson(newCourse, []);
//     _courses.add(newCourse);
      
//       // You can also update the local state or notify the user if needed
//     } else {
//       // Handle error response
//       final errorResponse = json.decode(response.body);
//       throw Exception("exception add new course ${errorResponse['message']}");
//     }
//   } catch (error) {
//     // Handle network errors or other exceptions
//     print('Failed to create new Course: $error');
//   }
// }
// */
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend1/pages/Template.dart';

class Course {
  final String name;
  final int mark;
  final String icon;
  final List<Assignment> assignments;
  final String id;

  Course({
    required this.name,
    required this.mark,
    required this.icon,
    required this.assignments,
    required this.id,
  });

  factory Course.fromJson(Map<String, dynamic> json, List<Assignment> allAssignments) {
    List<Assignment> courseAssignments = json['assignments'].map<Assignment>((id) {
      return allAssignments.firstWhere(
        (assignment) => assignment.id == id,
        orElse: () => Assignment(id: id, assignmentName: '', values: []),
      );
    }).toList();

    return Course(
      name: json['name'],
      mark: json['mark'],
      icon: json['icon'],
      assignments: courseAssignments,
      id: json['_id'],
    );
  }
}

class Assignment {
  final String? id;
  String assignmentName;
  List<dynamic>? values;

  Assignment({
    required this.id,
    required this.assignmentName,
    required this.values,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['_id'] as String?,
      assignmentName: json['assignmentName'] as String,
      values: json['values'] != null ? List<dynamic>.from(json['values']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'assignmentName': assignmentName,
      'values': values,
    };
  }
}

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  List<Assignment> _allAssignments = [];

  List<Course> get courses => _courses;
  set courses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }

  List<Assignment> get allAssignments => _allAssignments;
  set allAssignments(List<Assignment> assignments) {
    _allAssignments = assignments;
    notifyListeners();
  }

  Future<void> fetchCourses(String templateId, String token) async {
    try {
      var template = await Template.fetchTemplateData(templateId, token);
      print('Fetched Template Data: ${template?.data}');

      final assignmentResponse = await http.get(
        Uri.parse('http://$localhost/api/fetchAssignments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Assignments response body: ${assignmentResponse.body}');

      if (assignmentResponse.statusCode == 200) {
        List<dynamic> assignmentData = json.decode(assignmentResponse.body);
        _allAssignments = assignmentData
            .map((assignmentJson) => Assignment.fromJson(assignmentJson))
            .toList();

        final courseResponse = await http.get(
          Uri.parse('http://$localhost/api/fetchCourses/${template?.data}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (courseResponse.statusCode == 200) {
          List<dynamic> courseData = json.decode(courseResponse.body);
          courses = courseData
              .map((item) => Course.fromJson(item, _allAssignments))
              .toList();

          print("Courses data: ${courses[0].name}");
        } else {
          throw Exception('Failed to load courses: ${courseResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to load assignments: ${assignmentResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }
}
