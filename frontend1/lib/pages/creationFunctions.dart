
import 'dart:convert';
import 'package:frontend1/config.dart';
//import 'package:frontend1/pages/Template.dart';
//import 'package:frontend1/templates/AssignmentTracker/chartsCourses.dart';
//import 'package:frontend1/templates/Islam/MainIslam.dart';
//import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class functionServices {
  String ?userId;

 static Future<String?> retrieveUserInfo() async {
    String? token;
    String email;
String ?userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['_id'];
      /*
      setState(() {
        email = decodedToken['email'];
        userId = decodedToken['_id'];
      });
      */
    }
    return null;
    
  }
static Future<void> createCustomPage(String token,String templateId) async {
  const url = 'http://$localhost/api/custom-page'; // Update with your server URL
 String? userId= await functionServices.retrieveUserInfo();

  // Data to be sent in the request body
  final Map<String, dynamic> data = {
    'title': 'My Page',
    'BackgroundColor': 4294967295,
    'appBarColor': 4294967295,
    'icon': '📝',
    'toolBarColor': 4294967295,
    'userId': '$userId', // Replace with a valid user ID
    'elements': [],
  };

  try {
    // Send POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      },
      body: json.encode(data), // Convert data to JSON format
    );

    // Check response status
    if (response.statusCode == 201) {
      // Successful creation
      print('Custom page created successfully!');
      print('Response: ${response.body}');
    
    } else {
      // Failed to create custom page
      print('Failed to create custom page. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}


static Future<void> deleteCustomPage(String customPageId,String token) async {
  const String apiUrl = 'http://$localhost/api/customPage'; // Replace with your API endpoint

  try {
    // API endpoint
    final Uri url = Uri.parse('$apiUrl/$customPageId');

    // HTTP DELETE request
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Replace with your token-based auth
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Custom page deleted successfully: ${responseData['customPageId']}');
    } else if (response.statusCode == 404) {
      // Custom page not found
      print('Custom page not found: ${response.body}');
    } else {
      // Other error
      print('Failed to delete custom page. Status: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (error) {
    print('Error deleting custom page: $error');
  }
}

static Future<void> createTemplate(String token, String type, String title, String data) async {
  try {
    final response = await http.post(
      Uri.parse("http://$localhost/api/template"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'type': type,
        'title': title,
        'data': data,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print('Template created successfully');
      final responseBody = jsonDecode(response.body);
      print('Template ID: ${responseBody['template']['_id']}');
    } else {
      print('Failed to create template. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e, stackTrace) {
    print('Error occurred in createTemplate: $e');
    print('Stack trace: $stackTrace');
  }
}

  
static Future<String?> createCoursesArray(String token, dynamic templateId) async {
  try {
    final response = await http.post(
      Uri.parse('http://$localhost/api/createCoursesArray/$templateId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        print('Courses Array ID: ${responseBody['data']}');
        return responseBody['data'];
      } else {
        print('Response does not contain "data" field: $responseBody');
      }
    } else {
      print('Failed to create courses array. Status code: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print('Error occurred in createCoursesArray: $e');
    print('Stack trace: $stackTrace');
  }
  return null;
}


  
 static Future<String?> createFirstRoutine() async {
  final url = Uri.parse('http://$localhost/api/routines/createFirstRoutine'); // Replace with your actual API URL

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': "Islam",
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Routine created successfully!');
      print('IslamRoutineArray ID: ${responseData['islamRoutineArrayId']}');
      return responseData['islamRoutineArrayId'];
    } else {
      print('Failed to create routine. Status code: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  } catch (error) {
    print('Error occurred while creating routine: $error');
  }
  return null;
}

static Future<String> createAllMealsDays() async {
    try {
      final response = await http.post(
        Uri.parse("http://$localhost/api/allmealsdays"),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: jsonEncode({
          'days': []  // Empty 'days' array
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created the object
        print('AllMealsDays object created successfully!');
        // Optionally handle the response data
            final responseBody = jsonDecode(response.body);
        // Retrieve the 'id' from the nested 'data' field
        final createdId = responseBody['data']['_id'];
       print("id is $createdId");
       return createdId;

      } else {
        // Handle errors (non-201 status codes)
        print('Failed to create AllMealsDays object: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      // Catch any errors during the request
      print('Error creating AllMealsDays object: $e');
    }
    return "";
  }


static Future<void> createPortfolio(String token) async {
  // API endpoint
  final String apiUrl = 'http://$localhost/api/create-DefaultPortfolio';

  try {
    // Send POST request to create portfolio (empty body)
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
           'Authorization': 'Bearer $token',

      },
      // Sending an empty body since the data is preloaded on the backend
      body: '',
    );

    // Check the response status
    if (response.statusCode == 201) {
      print('Default Portfolio created successfully');
      // Optionally, you can parse the response if needed
      final responseData = response.body;
      print(responseData);
    } else {
      print('Failed to create portfolio. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error creating portfolio: $error');
  }
}


static Future<void> deletePortfolio(String portfolioId,String token) async {
  const String apiUrl = 'http://$localhost/api/portfolio'; // Replace with your API URL

  try {
    // API endpoint
    final Uri url = Uri.parse('$apiUrl/$portfolioId');

    // HTTP DELETE request
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Replace with your token-based auth
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Portfolio deleted successfully: ${responseData['portfolioId']}');
    } else if (response.statusCode == 404) {
      // Portfolio not found
      print('Portfolio not found: ${response.body}');
    } else {
      // Other error
      print('Failed to delete portfolio. Status: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (error) {
    print('Error deleting portfolio: $error');
  }
}

static Future<void> deleteTemplate(String templateId, String userToken) async {
   String baseUrl = 'http://$localhost/api/template/$templateId'; // Replace with your API's base URL
  try {
    final url = Uri.parse(baseUrl);

    // Prepare the request headers and body
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken', // Replace with your token handling method
    };
    final body = jsonEncode({'templateId': templateId});

    // Make the HTTP request
    final response = await http.delete(
      url,
      headers: headers,
      body: body,
    );

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Success: ${responseData['message']}');
    } else {
      final errorData = jsonDecode(response.body);
      print('Error: ${errorData['error']}');
    }
  } catch (error) {
    print('Failed to delete template: $error');
  }
}



static Future<void> postFinanceData(String token) async {
  try {
    final response = await http.post(
      Uri.parse('http://$localhost/api/finances/defaultFinance'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${token}',
      },
    );

    // Check the response from the server
    if (response.statusCode == 200) {
      print("Finance data created successfully: ${response.body}");
    } else {
      print("Failed to create finance data: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error posting finance data: $e");
  }
}

}