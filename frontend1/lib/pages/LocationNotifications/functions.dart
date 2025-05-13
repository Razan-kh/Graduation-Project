



import 'dart:convert';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';



  Future<String?> retrieveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
       String userId = decodedToken['_id'];
       return userId;

    }
  }

/*
// Example of adding a reminder
void createReminder() async {
  try {
    await addReminder(
      'userIdHere', 
      'This is a reminder', 
      'locationIdHere', 
      {'latitude': 10.0, 'longitude': 20.0, 'address': 'Some address'}, 
      30,
    );
    print('Reminder added');
  } catch (e) {
    print('Error adding reminder: $e');
  }
}
*/

Future<List<Map<String, dynamic>>> getReminders() async {
  String? userId=await retrieveUserInfo();
 // if(userId!=null && userId!.isNotEmpty)
  final String url = 'http://$localhost/api/user/$userId/reminders'; // Replace with your API URL
   // print("hi");
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Successfully fetched reminders
   final data = jsonDecode(response.body);
    
     // print("data is $data"); 
      return List<Map<String, dynamic>>.from(data['reminders']);
    } else {
      throw Exception('Failed to load reminders');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;  // Re-throw the error to handle it in the UI
  }
}


// Function to fetch locations
Future<List<Map<String, dynamic>>> fetchLocations() async {
  String? userId =await retrieveUserInfo();
  final url = Uri.parse('http://$localhost/api/user/$userId/locations');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the response body and return locations as a list of maps
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error fetching locations');
  }
}


// Function to add a new location
Future<void> addLocation( String name, double latitude, double longitude) async {
 String? userId=await retrieveUserInfo();
  final url = Uri.parse('http://$localhost/api/user/$userId/locations');

  final Map<String, dynamic> locationData = {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
   
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(locationData),
    );

    if (response.statusCode == 201) {
      print('Location added successfully');
    } else {
      throw Exception('Failed to add location');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding location');
  }
}



Future<void> deleteReminder(String reminderId) async {
    String? userId=await retrieveUserInfo();
  final url = Uri.parse('http://$localhost/api/users/$userId/reminders/$reminderId');

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData['message']); // "Reminder deleted successfully"
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['message']}'); // User or reminder not found
    } else {
      print('Error: Failed to delete reminder. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}