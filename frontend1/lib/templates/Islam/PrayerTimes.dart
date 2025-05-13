


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Islam/MainIslam.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Ensure Google Fonts is imported

class PrayingTimes extends StatefulWidget {
  List<dynamic> prayers = [];
  String RoutineID;
final VoidCallback onAdd;
  PrayingTimes({
    Key? key,
    required this.prayers,
    required this.RoutineID,
    required this.onAdd,
  }) : super(key: key);

  @override
  PrayingTimesState createState() => PrayingTimesState();
}

class PrayingTimesState extends State<PrayingTimes> {
  List<Prayer> prayerList = [];
  final List<String> prayingNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  Map<String, String> prayerTimes = {}; // To store fetched prayer times
  bool isLoading = true; // Loading state for the UI

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    // Cancel any active subscriptions, streams, or timers
    print('Disposing PrayingTimes widget');
    super.dispose();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showError('Location services are disabled.');
      return;
    }

    // Request permission if it hasn't been granted yet
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showError(
          'Location permissions are permanently denied. We cannot request permissions.');
      return;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition();
      fetchPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      showError('Error fetching location: $e');
    }
  }

  Future<void> fetchPrayerTimes(double latitude, double longitude) async {
    print("inside fetchPrayerTimes");
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          prayerTimes = Map<String, String>.from(data['data']['timings']);
          print(prayerTimes);
          isLoading = false;
        });
      } else {
        showError(
            'Failed to load prayer times. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error fetching prayer times: $e');
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    print(message); // You can replace this with a Snackbar or AlertDialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> togglePrayer(String prayerName) async {
  
    final String baseUrl = 'http://$localhost';
    final url = Uri.parse(
        '$baseUrl/api/routines/${widget.RoutineID}/prayers/$prayerName/toggle');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
         // widget.onAdd();
        print("Prayer toggled successfully");
        // Optionally, update the UI based on response
      } else {
        throw Exception("Failed to toggle prayer: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error toggling prayer: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0), // Consistent padding
        
          child:  SingleChildScrollView(
            child: Column(
              children: widget.prayers.asMap().entries.map((entry) {
                final index = entry.key; // The current index
                final prayer = entry.value; // The prayer object

                return RectangleWidget(
                  prayer: prayer,
                  togglePrayer: togglePrayer,
                  eventTime: prayerTimes[prayer.name] ?? '',
                  icon: _getIconForIndex(index),
                );
              }).toList(), // Convert Iterable to List
            ),
          ),
           
        );
}
            
    
  

  // Helper method to get different icons based on index
  Image _getIconForIndex(int index) {
    List<Image> icons = [
      Image.asset('lib/images/fajr.png', width: 30.0, height: 30.0),
      Image.asset('lib/images/duhr.png', width: 30.0, height: 30.0),
      Image.asset('lib/images/Asr.png', width: 30.0, height: 30.0),
      Image.asset('lib/images/maghrib.png', width: 30.0, height: 30.0),
      Image.asset('lib/images/Isha.png', width: 30.0, height: 30.0),
    ];
    return icons[index % icons.length];
  }
}

class RectangleWidget extends StatefulWidget {
  final Prayer prayer;
  final Image icon;
  final String eventTime;

  final Future<void> Function(String prayerName) togglePrayer;

  const RectangleWidget({
    Key? key,
    required this.prayer,
    required this.togglePrayer,
    required this.icon,
    required this.eventTime,
  }) : super(key: key);

  @override
  _RectangleWidgetState createState() => _RectangleWidgetState();
}

class _RectangleWidgetState extends State<RectangleWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Lighter shadow for consistency
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          widget.icon, // Use the passed icon
          SizedBox(width: 12.0), // Consistent spacing
          Expanded(
            child: Text(
              widget.prayer.name,
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            widget.eventTime,
            style: GoogleFonts.montserrat(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              _isPressed
                  ? Icons.notifications_off_outlined
                  : Icons.notifications_active_outlined,
              color: Colors.blue, // Primary color for consistency
            ),
            onPressed: () {
              setState(() {
                _isPressed = !_isPressed; // Toggle the icon state
              });
              widget.togglePrayer(widget.prayer.name);
            },
          ),
          Checkbox(
            value: widget.prayer.isCompleted,
            activeColor: Colors.blue, // Primary color for consistency
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  widget.prayer.isCompleted = value;
                });
                widget.togglePrayer(widget.prayer.name);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Prayer {
  final String name;
  final String time;
  bool isCompleted;
  bool notificationEnabled;
  final String id;

  Prayer({
    required this.name,
    required this.time,
    this.isCompleted = false,
    this.notificationEnabled = true,
    required this.id,
  });

  // Factory method to create a Prayer from a map (used to parse JSON or response)
  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      name: json['name'],
      time: json['time'],
      isCompleted: json['isCompleted'],
      notificationEnabled: json['notificationEnabled'],
      id: json['_id'],
    );
  }

  // Method to convert Prayer instance back to map (if you need to send back to API)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'isCompleted': isCompleted,
      'notificationEnabled': notificationEnabled,
      '_id': id,
    };
  }
}

class PrayerTimes extends StatelessWidget {
  final List<Prayer> prayers;
  final String routineID;

  PrayerTimes({required this.prayers, required this.routineID});

  @override
  Widget build(BuildContext context) {
    return

     Padding(
      padding: EdgeInsets.symmetric(),
child: Column(
  children: prayers.map((prayer) {
    return ListTile(
      title: Text(
        prayer.name,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: prayer.isCompleted
              ? Colors.grey
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        prayer.time,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          color: prayer.isCompleted
              ? Colors.grey
              : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
        ),
      ),
      trailing: Icon(
        prayer.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: prayer.isCompleted
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      onTap: () {
        // Handle prayer completion toggle
        // Implement functionality to mark prayer as completed
      },
    );
  }).toList(),
),

    );
  }
}