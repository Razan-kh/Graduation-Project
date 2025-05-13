import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend1/pages/LocationNotifications/functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final MapController _mapController = MapController();
  Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  TextEditingController _nameController = TextEditingController();
   LatLng _currentLocation = LatLng(37.7749, -122.4194); // Default to San Francisco
  bool _locationFetched = false;


  @override
 void initState()
 {
  super.initState();
      _getUserLocation(); // Fetch user's location when the widget is created

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Location'),
      ),
      body:!_locationFetched?
      Align(
        alignment: Alignment.center,
        child:  CircularProgressIndicator(),
      )
      :
       Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
              //  center: LatLng(37.7749, -122.4194), // Default to San Francisco
              initialCenter: _currentLocation,
              //  zoom: 14,
                onTap: _onTapMap, // Type cast to TapCallback?
              ),
              children: [
             
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app', // Add your app's package name for user agent
    ),
  
                MarkerLayer(
                  markers: _markers.toList(),
                ),
              ],
            ),
          ),
          if (_selectedLocation != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Location Name'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ButtonStyle(  backgroundColor: MaterialStateProperty.all((Colors.grey[50])),),
                    onPressed: _saveLocation,
                    child: Text('Save Location',style: TextStyle(color: Colors.blue),),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _onTapMap(TapPosition tapPosition, LatLng latLng) {
  // Your logic here, using both tapPosition and latLng
  setState(() {
    _selectedLocation = latLng; // Use latLng for the location
    _markers.clear(); // Clear previous markers
    _markers.add(Marker(
      point: latLng, // Use latLng for the marker point
      child: Icon(
        Icons.pin_drop,
        color: Colors.red,
      ),
    ));
  });
}



  void _saveLocation()async {
    if (_selectedLocation != null && _nameController.text.isNotEmpty) {
      final newLocation = Location(
        name: _nameController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );
      // You would save the location to your backend here.
      print('Location saved: ${newLocation.name}, ${newLocation.latitude}, ${newLocation.longitude}');
     await addLocation( newLocation.name, newLocation.latitude, newLocation.longitude);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location stored successfully')));
setState(() {
  _selectedLocation=null;
  _nameController.text="";
});
    //  Navigator.pop(context);  // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please provide a name and select a location')));
    }
  }
    Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle appropriately
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Handle permission denial
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Update the map center with the user's location
    setState(() {
   
      _currentLocation = LatLng(position.latitude, position.longitude);
         print(_currentLocation);
      _locationFetched = true;
    });
  }
}

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({required this.name, required this.latitude, required this.longitude});


  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name:json['name'],
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}