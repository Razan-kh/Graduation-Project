
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
class Reminder {
  final String description;
  final Location location;
  final int triggerAfterMinutes;
final String id;
bool isTriggered;
  Reminder({required this.description, required this.location, required this.triggerAfterMinutes,required this.id, this.isTriggered=false});

    factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      description: json['description'] as String,
      location: Location.fromJson(json['location']),
      triggerAfterMinutes: json['triggerAfterMinutes'] as int,
      id :json['_id'],
      isTriggered: json['isTriggered']
    );
  }
}
/*
class ReminderScreen extends StatefulWidget {
  final List<Location> availableLocations;

  ReminderScreen({required this.availableLocations});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TextEditingController _descriptionController = TextEditingController();
  int _triggerAfterMinutes = 30; // Default trigger time after 30 minutes
  Location? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Reminder Description'),
            ),
            SizedBox(height: 8),
            DropdownButton<Location>(
              value: _selectedLocation,
              hint: Text('Select Location'),
              onChanged: (Location? newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: widget.availableLocations.map<DropdownMenuItem<Location>>((Location location) {
                return DropdownMenuItem<Location>(
                  value: location,
                  child: Text(location.name),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text('Trigger after:'),
            Slider(
              value: _triggerAfterMinutes.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              label: '$_triggerAfterMinutes minutes',
              onChanged: (double value) {
                setState(() {
                  _triggerAfterMinutes = value.toInt();
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveReminder,
              child: Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveReminder() {
    if (_selectedLocation != null && _descriptionController.text.isNotEmpty) {
      final newReminder = Reminder(
        description: _descriptionController.text,
        location: _selectedLocation!,
        triggerAfterMinutes: _triggerAfterMinutes,
      );
      // Save the reminder to the backend
      print('Reminder saved: ${newReminder.description}, at ${newReminder.location.name}, triggered after ${newReminder.triggerAfterMinutes} minutes');
      
      Navigator.pop(context);  // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    }
  }
}
*/