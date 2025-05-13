/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;



class HobbiesPage extends StatefulWidget {
  final String token;
  HobbiesPage({required this.token});
  @override
  _HobbiesPageState createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<HobbiesPage> {
  List<Hobby> hobbies =[];

  @override
  void initState() {
    super.initState();
    fetchHobbies();
  }

  // Fetch hobbies from the backend API
  Future<void> fetchHobbies() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/portfolio/hobbies'), // Replace with your backend URL
      headers: {
        'Authorization': 'Bearer ${widget.token}', // Include the JWT token
      },
    );

    if (response.statusCode == 200) {
       List<dynamic> data = json.decode(response.body);
   data=data.hobbies;
   print(" data is $data");
      setState(() {
        hobbies = data.map((item) => Hobby.fromJson(item)).toList();
      });
    
    } else {
      print('Failed to load hobbies');
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return    SizedBox(
    
  height: hobbies.length*100,
  child: 
        GridView.builder(
       
          itemCount: hobbies.length,
           // Allows GridView to size itself based on content
        shrinkWrap: true, // Ensures GridView takes up only the space it needs
          physics: NeverScrollableScrollPhysics(), // Dis
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            Hobby hobby = hobbies[index];
            return HobbyCard(
              title: hobby.title,
              icon: Icons.star,  // Placeholder icon
              description: hobby.description,
              imageUrl: hobby.imageUrl,
            );
          },

        ),
        
    );
  }
}

class HobbyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final String imageUrl;

  HobbyCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Hobby Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Icon and Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Color(0xFF76c7c0),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Description of the hobby or achievement
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Hobby {
  String title;
  String description;
  String imageUrl;

  Hobby({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

}

*/