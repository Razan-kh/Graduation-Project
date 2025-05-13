import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/LocationNotifications/functions.dart';
import 'package:frontend1/pages/LocationNotifications/geoFencing.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
import 'package:frontend1/pages/LocationNotifications/reminderNotification.dart';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:frontend1/templates/sideBar.dart';

class ReminderScreen1 extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen1> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController triggerTimeController = TextEditingController();

  late String selectedLocation;
    late String selectedLocationId;
  List<Map<String, dynamic>> reminders = [];
  late List<Map<String, dynamic>> locations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final reminders0 = await getReminders();
      final locations0 = await fetchLocations();

      setState(() {
        reminders = reminders0;
        locations = locations0;
        loading = false;
       selectedLocation = locations.isNotEmpty ? locations[0]['name'] : 'None';
        selectedLocationId=locations.isNotEmpty ? locations[0]['_id'] : '';

      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error fetching data: $e');
    }
  }


  void _showAddReminderDialog() {

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (locations.isEmpty) {
            // Show a message to create a location first
            return AlertDialog(
              title: const Text('No Locations Found'),
              content: const Text(
                  'You need to create a location before adding a reminder.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                  //  Navigator.pop(context); // Close the dialog
                  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationScreen(),
            ),
          ).then((value) {
    _initializeData(); // Refresh data when returning from the location screen
  });
          // Navigate to location creation
                  },
                  child: const Text('Create Location'),
                ),
              ],
            );
          }

     return   AlertDialog(
          title: const Text('Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: triggerTimeController,
                  decoration: const InputDecoration(labelText: 'Trigger After (Minutes)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedLocation,
                  onChanged:locations.isNotEmpty
      ? 
                   (String? newValue) {
                    setState(() {
                        selectedLocation = newValue!;
                        if (newValue == 'Custom') {
                          selectedLocationId = "";
                        } else {
                          // Update selectedLocationId based on the selected location name
                          final location = locations.firstWhere(
                              (loc) => loc['name'] == newValue,
                              orElse: () => {});
                          selectedLocationId = location.isNotEmpty ? location['_id'] : null;
                        }
                      });
                    
                  }:
                  null,
                  items: locations
                      .map<DropdownMenuItem<String>>((Map<String, dynamic> location) {
                        return DropdownMenuItem<String>(
                          value: location['name'],
                          child: Text(location['name'] ?? ''),
                        );
                      })
                      .toList(),
                /*     ..add(
                     DropdownMenuItem<String>(
                        value: 'Custom',
                        child: const Text('Custom'),
                      ),
                    ),
                    */
                ),

                
                
                if (selectedLocation == 'Custom') ...[
                  TextField(
                    controller: latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  final customLocation = selectedLocation == 'Custom'
                      ? {
                          'latitude': latitudeController.text,
                          'longitude': longitudeController.text,
                        }
                      : null;
                  final triggerTime = int.tryParse(triggerTimeController.text) ?? 1;

                //createReminder();
                addReminder(descriptionController.text, selectedLocationId, customLocation,triggerTime,selectedLocation);
                Navigator.pop(context);
              },
              child: const Text('Add Reminder'),
            ),
          ],
        );
      },
     
    );
      },
       );

  }

  Widget _buildReminderList() {
    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
         return Dismissible(
        key: Key(reminder['_id'].toString()), // Ensure each item has a unique key
        direction: DismissDirection.endToStart, // Swipe direction (right-to-left)
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
                    return await _showDeleteConfirmationDialog(context);
                  },

        onDismissed: (direction) {
          // Handle dismissal logic (e.g., remove item from the list)
         deleteReminder( reminder['_id']).then((_) {
    setState(() {
      String id=reminder['_id'];
      // Remove the reminder from your local list after successful deletion
      reminders.removeWhere((reminder) =>id == reminder['_id']);
    });
  }).catchError((error) {
    print('Failed to delete reminder: $error');
  });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reminder dismissed')),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(reminder['description']),
            subtitle: Text('Trigger after ${reminder['triggerAfterMinutes']} minutes'),
          trailing: Text(
             reminder['locationName'] != null && reminder['locationName'].isNotEmpty
          ? reminder['locationName'] :
  reminder['locationId'] != null && reminder['locationId'].isNotEmpty
      ? reminder['locationId'] // Display locationId if it's available
      :// Display LocationName if it's available
           'No location', // Default message if neither is available
),

            onTap: () {
              // Handle tap actions if needed
            },
          ),
        ),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reminder'),
          content: Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
        bool isWeb=MediaQuery.of(context).size.width>1200? true: false;

    return Scaffold(
      appBar:isWeb?null
      : AppBar(
        title: const Text('Reminders'),
      ),
      body: Row(
  children: [
      if (isWeb) WebSidebar(),
    if (isWeb) SizedBox(width: 170), // Spacer for web layout
   Expanded(
          flex: 5, // Adjust flex to allocate space proportionally
  
      child:
       loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                    onPressed: _showAddReminderDialog,
                    child: const Text('Add Reminder',style: TextStyle(color: Colors.blue),),
                  ),
                  ),
                  
                  Expanded(
                    child: _buildReminderList(),
                  ),
                 
                ],
              ),
            ),
   ),
       if (isWeb) SizedBox(width: 100), // Spacer for web layout

  ]
   )
    
    ); 
  }
  
Future<void> addReminder( String description, String locationId, Map<String, dynamic>? customLocation, int triggerAfterMinutes,String LocationName) async {
String ?userId =await retrieveUserInfo();
  final String url = 'http://$localhost/api/user/$userId/reminders'; // Replace with your API URL
  
  final Map<String, dynamic> reminderData = {
    'description': description,
    'locationId': locationId,
    'customLocation': customLocation,
    'triggerAfterMinutes': triggerAfterMinutes,
    'locationName':LocationName
  };
print(reminderData);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reminderData),
    );

    if (response.statusCode == 201) {
      // Reminder added successfully
      final data = jsonDecode(response.body); 
      final reminderId=data['reminder']['_id'];
      print(reminderId);
      print('Reminder added successfully');
       Map<String, dynamic> lo = locations.firstWhere((loc) => loc['_id'] == locationId);
       Location Locat =Location.fromJson(lo);
    print('Found location: $Locat');
   
     Reminder r=Reminder(location: Locat,description: description,triggerAfterMinutes: triggerAfterMinutes,id: reminderId);
      setState(() {
        reminders.add(reminderData);
      });
  
     startGeofencing(r);

    } else {
      throw Exception('Failed to add reminder');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;  // Re-throw the error to handle it in the UI
  }
}

/*
  Future<List<Map<String, dynamic>>> getReminders() async {
    // Replace this with actual API call to fetch reminders
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        {'description': 'Test Reminder', 'triggerAfterMinutes': 15, 'locationId': 'Home'},
      ],
    );
  }
*/
/*
  Future<List<Map<String, dynamic>>> fetchLocations() async {
    // Replace this with actual API call to fetch locations
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        {'name': 'Home'},
        {'name': 'Office'},
      ],
    );
  }

  void createReminder() {
    final reminder = {
      'description': descriptionController.text,
      'triggerAfterMinutes': int.tryParse(triggerTimeController.text) ?? 0,
      'locationId': selectedLocation == 'Custom'
          ? {
              'latitude': double.tryParse(latitudeController.text),
              'longitude': double.tryParse(longitudeController.text),
            }
          : selectedLocation,
    };

    setState(() {
      reminders.add(reminder);
    });

    // Optionally send the reminder to an API
    print('Reminder created: $reminder');

    // Clear inputs
    descriptionController.clear();
    triggerTimeController.clear();
    latitudeController.clear();
    longitudeController.clear();
  }
  */
}