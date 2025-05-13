import 'package:flutter/material.dart';
import 'package:frontend1/pages/BrowseTemplatesPage.dart';
import 'package:frontend1/pages/NotificationModel.dart';
import 'package:frontend1/pages/UserNotification.dart';
import 'package:frontend1/pages/stickyNotesPage.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/BrowseTemplatesPage.dart';
import 'package:frontend1/pages/home_page.dart';
//import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/pages/signup_page.dart';
//import 'package:frontend1/templates/AssignmentTracker/chartsCourses.dart';
//import 'package:frontend1/templates/Islam/MainIslam.dart';
//import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class footerClass extends StatefulWidget {
  @override
 footerState createState() => footerState();


}

class footerState extends State<footerClass> {
  String? token;
  @override
  void initState()
  {
    super.initState();
    fetchToken();
  }
    void fetchToken()async {
     String ?token0=await retrieveUserInfo() ;
    if(token0 !=null) 
    setState(() {
      token=token0;
    });

    }
 
 Widget _footer() {
  //await NotificationService.fetchUnreadNotificationCount();

   // print("unread is ${NotificationService.unreadMessages}");
   /*
  return 
     
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  child:
  */return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Icon(Icons.home, color: Colors.blue, size: 28), // Active icon (Dashboard/Home)
      const Icon(Icons.search, color: Colors.grey, size: 28),
      /*
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsScreen(token: token!),
            ),
          );
        },
        child: Icon(Icons.folder, color: Colors.grey, size: 28),
      ),
      */   
      IconButton(
          //Notification Icon 
  icon: Stack(
    children: [
      Icon(Icons.folder,size: 29,color: Colors.grey,),
    
      if (NotificationService.unreadMessages > 0)
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Text(
              NotificationService.unreadMessages.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
    ],
  ),
  onPressed: () async {
    // Open the notifications screen
        await NotificationService.markNotificationsAsRead();
        setState(() {
          NotificationService.unreadMessages=0;
        });
        if(token!=null)
   Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsScreen(token: token!),
            ),
          );
    // Mark all notifications as read when opening
  },
),

       GestureDetector(
                onTap: () {
                   if(token!=null)
                 Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => StickyNotesPage(token: token!),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // No transitions
    },
  ),
);

                },
                child: Icon(Icons.edit, color: Colors.grey, size: 28),
              ),
    ],
 // ),
);

 
}

  @override
  Widget build(BuildContext context) {

 return
 Padding(
  padding: EdgeInsets.all(1.0),
 child: footerClass()
 );
  }
  

  
 static Future<String?> retrieveUserInfo() async {
    String? token;
    String email;
String ?userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
    
    
      return token;
    
    }
    
  }
  

}