
/*
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/BrowseTemplatesPage.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
import 'package:frontend1/pages/LocationNotifications/reminderNotification.dart';
import 'package:frontend1/pages/LocationNotifications/reminders.dart';
import 'package:frontend1/pages/NotificationModel.dart';
import 'package:frontend1/pages/UserNotification.dart';
import 'package:frontend1/pages/creationFunctions.dart';
import 'package:frontend1/pages/footer.dart';
import 'package:frontend1/pages/login_page.dart';
import 'package:frontend1/pages/stickyNotesPage.dart';
import 'package:frontend1/templates/CustomizedPage/home_page0.dart';
import 'package:frontend1/templates/Finance/main.dart';
import 'package:frontend1/templates/Finance/main0.dart';
import 'package:frontend1/templates/StudyPlannerPage/student_planner2.dart';
import 'package:frontend1/templates/collaboration_template/main_page.dart';
import 'package:frontend1/templates/cv_template/cv_template_section.dart';
import 'package:frontend1/templates/dashboard_template/student_planner.dart';
import 'package:frontend1/templates/internship_template.dart/internship_page.dart';
import 'package:frontend1/templates/page_template/home_page.dart';

import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/AssignmentTracker/chartsCourses.dart';
import 'package:frontend1/templates/Islam/MainIslam.dart';
import 'package:frontend1/templates/Portfolio/AboutMe.dart';
import 'package:frontend1/templates/AssignmentTracker/chartsCourses.dart';

import 'package:frontend1/templates/postgrad_template/post_grad_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? email;
  List<dynamic> userTemplates = [];
  String? userId;
  String? token;

  final Map<String, String> manualTemplateTitles = {
    'postgraduate': 'Postgraduate Applications',
    'studentplanner': 'Study Planner',
    'project': 'Collaboration Projects',
    'cv': 'Curriculum Vitae (CV)',
    'internship': 'Internship Applications',
    'student_planner': 'Study Planner Dashboard',
    'My Page':'My Page',
    'Islam':'Islam',
    'Assignment':'Assignment',
    'MealsTracker':'MealsTracker',
    'Portfolio':'Portfolio',
    'Finance':'Finance'
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchUnreadNotificationCount();
    await _retrieveUserInfo();
    await _fetchUserTemplates();
  
  }

  Future<void> _retrieveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        email = decodedToken['email'];
        userId = decodedToken['_id'];
      });
    }
  }

  Future<void> _fetchUserTemplates() async {
    const url = 'http://$localhost/api/template';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userTemplates = data['templates'];
        });
      } else {
        print('Failed to load user templates');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _deleteTemplate(String templateId, String templateTitle) async {
    String endpoint;

    switch (templateTitle) {
      case 'cv':
        endpoint = 'http://$localhost/api/cv/$templateId';
        break;
      case 'internship':
        endpoint = 'http://$localhost/api/internship/template/$templateId';
        break;
      case 'postgraduate':
        endpoint = 'http://$localhost/api/postgraduate/$templateId';
        break;
      case 'project':
        endpoint = 'http://$localhost/api/project/$templateId';
        break;
      case 'studentplanner':
        endpoint = 'http://$localhost/api/studentplanner/$templateId';
        break;
      case 'student_planner':
      endpoint = 'http://$localhost/api/studentplanner2/$templateId';
      break;  
      case 'Finance' :
      endpoint='http://$localhost/api/finance/$templateId';
      break;
      default:
        print('Unknown template type');
        return;
    }

    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userTemplates.removeWhere((template) => template['templateId'] == templateId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete template.')),
        );
      }
    } catch (error) {
      print('Error deleting template: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while deleting the template.')),
      );
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Template'),
          content: Text('Are you sure you want to delete this template?'),
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

  void _navigateToTemplate(String templateTitle, String templateId) {
    if (templateTitle == "postgraduate") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostgraduateAppPage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "studentplanner") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPlanner2App(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "project") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollaborationPage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "cv") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVEditorScreen(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "student_planner") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPlanner(token: token!, templateId: templateId),
        ),
      );
    }
     else if (templateTitle == "internship") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InternshipApplicationsWidget(token: token!, templateId: templateId),
        ),
      );
    } 
      else if (templateTitle == "Assignment") {
      Navigator.push(
        context,
        MaterialPageRoute(
              builder: (context) => CourseScreen(
                  token: token!, templateId: templateId),
            ),
      );
    }
      else if (templateTitle == "MealsTracker") {
        print("template id is $templateId");
      Navigator.push(
        context,
        MaterialPageRoute(
              builder: (context) =>
                  MealsMain(token: token!, templateId: templateId),
            ),
      );
    }
      else if (templateTitle == "Islam") {
      Navigator.push(
        context,
         MaterialPageRoute(
              builder: (context) => IslamicAppHomePage(
                  token: token!, templateId: templateId),
            ),
      );
    }
    else if (templateTitle== "Portfolio") {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutMeScreen(token: token!,templateId: templateId,),
            ),
          );
        }
          else if (templateTitle== "Finance") {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => mainFinance(token: token!,financeId: templateId,),
            ),
          );
        }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageScreen(token: token!, templateId: templateId),
        ),
      );
    }
  }

  void _refreshUserTemplates() {
    _fetchUserTemplates();
  }
@override
Widget build(BuildContext context) {
  bool isWeb=MediaQuery.of(context).size.width>600 ?true:false;
  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: AppBar(
      backgroundColor: Colors.blue,
      toolbarHeight: 60,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showAccountOptions(context),
            child: Row(
              children: [
                Text(
                  "${email?.split('@')[0]}'s Planly",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
          Text(
            email ?? 'Loading...',
            style: GoogleFonts.montserrat(
             // color: Colors.grey[700],
             color:Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) {
          return MediaQuery.of(context).size.width < 600
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : SizedBox.shrink(); // Hide the drawer icon on larger screens
        },
      ),
      actions: [
        if (MediaQuery.of(context).size.width >= 600) ...[
          // Top navigation for Web with icons aligned to the right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align icons to the right
              children: [
            
                TextButton(child:Text('Home',style: TextStyle(fontSize: 18,color: Colors.white)), onPressed: (){},),
                SizedBox(width:12),
                TextButton(child:Text('Search',style: TextStyle(fontSize: 18,color: Colors.white)), onPressed: ()async{
                    final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseTemplatesPage(
                    token: token!,
                    onTemplateAdded: _refreshUserTemplates,
                  ),
                ),
              );

              if (result == true) {
                _fetchUserTemplates();
              }
            
                },),
                    SizedBox(width:12),
                TextButton(child:Text('Notifications',style: TextStyle(fontSize: 18,color: Colors.white)), onPressed: (){
                   Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsScreen(token: token!),
            ),
          );
                },),
                    SizedBox(width:12),
                TextButton(child:Text('Notes',style: TextStyle(fontSize: 18,color: Colors.white)), onPressed: (){
                    Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => StickyNotesPage(token: token!),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // No transitions
    },
  ),
);
                },),
                 SizedBox(width:12),
                TextButton(child:Text('My Page',style: TextStyle(fontSize: 18,color: Colors.white)), onPressed: (){
                  
    if (token != null) {
                      createCustomPage(token!); // Use the retrieved token
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token is missing. Please log in again.')),
                      );
                    }
      
      
                }),
          SizedBox(width:35),

              ],
            ),
          ),
        ],
      ],
    ),
    drawer: LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? Drawer(
                child: _buildDrawerContent(),
              )
            : SizedBox.shrink(); // No drawer for larger screens.
      },
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Row(
          children: [
            if (!isMobile)
              // Sidebar on Web, placed on top of the AppBar
              Container(
                width: 250, // Adjust the width as needed for the sidebar
                color: Colors.white,
                child: _buildDrawerContent(), // Persistent sidebar for web.
              ),
            Expanded(
              child:
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Templates',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: userTemplates.length,
                      itemBuilder: (context, index) {
                        final template = userTemplates[index];
                        final String templateTitle =
                            manualTemplateTitles[template['title']] ?? template['title'];

                        return Dismissible(
                          key: Key(template['templateId']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return await _showDeleteConfirmationDialog(context);
                          },
                          onDismissed: (direction) async {
                            // Handle template deletion logic here
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              leading: Text(
                                template['icon'] ?? '📄',
                                style: const TextStyle(fontSize: 22),
                              ),
                              title: Text(
                                templateTitle,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              onTap: () => _navigateToTemplate(template['title'], template['templateId']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                /*  if (isMobile) //_footer(),
 Container(
    color: Colors.white,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseTemplatesPage(
                    token: token!,
                    onTemplateAdded: _refreshUserTemplates,
                  ),
                ),
              );

              if (result == true) {
                _fetchUserTemplates();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey, size: 24),
                      SizedBox(width: 8),
                      Text('Browse templates', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            
          ),
        )
    
                ], //
              ),
            ),
            */
    //  _footer()
          ],
        
        )
        ),
        if(!isMobile)SizedBox(width:100)
          ]
        );
      },
    ),
  );
}



 Widget _footer() {
  //await NotificationService.fetchUnreadNotificationCount();

   // print("unread is ${NotificationService.unreadMessages}");
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseTemplatesPage(
                    token: token!,
                    onTemplateAdded: _refreshUserTemplates,
                  ),
                ),
              );

              if (result == true) {
                _fetchUserTemplates();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey, size: 24),
                      SizedBox(width: 8),
                      Text('Browse templates', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  child: Row(
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
  ),
),

      ],
    ),
  );
}


// Add this method for showing the account options (logout and other accounts)
void _showAccountOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accounts',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.black),
              ),
              title: Text(
                email ?? '${email}',
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
              trailing: Icon(Icons.check, color: Colors.blue),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log out',
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red),
              ),
              onTap: () async {
                // Log out the user
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

  Future<void> createCustomPage(String token) async {
    const url = 'http://$localhost/api/custom-page'; // Update with your server URL

    // Data to be sent in the request body
    final Map<String, dynamic> data = {
      'title': 'My Page',
      'BackgroundColor': 4294967295,
      'appBarColor': 4294967295,
      'icon': '📝',
      'toolBarColor': 4294967295,
      'userId': '$userId', // Use retrieved user ID
      'elements': [],
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data), // Convert data to JSON format
      );

      // Check response status
      if (response.statusCode == 201) {
        // Successful creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom page created successfully!')),
        );
        _fetchUserTemplates(); // Refresh the user's templates
      } else {
        // Failed to create custom page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create custom page.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while creating the page.')),
      );
    }
  }


 Future<void> fetchUnreadNotificationCount() async {
  String ?token=await NotificationService.retrieveUserToken();
  final url = Uri.parse('http://$localhost/api/unread-count');  // Update the URL

  try {
    // Send GET request to the backend API with the token in the Authorization header
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',  // Include the token in the header for authentication
      },
    );

    // Check if the response status is OK
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      NotificationService.unreadMessages=data['unreadCount'];
      print("unread messages is ${NotificationService.unreadMessages}");
      setState(() {
        
      });
      }
       
     else {
      throw Exception('Failed to load unread notifications');
    }
  } catch (error) {
    print('Error fetching unread notification count: $error');
   
  }
}

  _buildDrawerContent() {
     final isWeb = MediaQuery.of(context).size.width > 600; 
 return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Drawer(
  backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            if(!isWeb)
            Container(
              height: 120,  // Adjust the height as needed
              color: Colors.blue,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,  // Make the background transparent
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Locations'),
              onTap: () {
                // Handle tap
              //  Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:(context)=>LocationScreen() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.notification_add),
              title: Text('Reminders'),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context)=>
            ReminderScreen1()
               ));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout',style:TextStyle( color:Colors.red,)),
              onTap: () {
                // Handle tap
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
        );
      
  }
}
*/
//----------------------------------------

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/BrowseTemplatesPage.dart';
import 'package:frontend1/pages/LocationNotifications/locations.dart';
import 'package:frontend1/pages/LocationNotifications/reminders.dart';
import 'package:frontend1/pages/NotificationModel.dart';
import 'package:frontend1/pages/UserNotification.dart';
import 'package:frontend1/pages/creationFunctions.dart';
import 'package:frontend1/pages/login_page.dart';
import 'package:frontend1/pages/stickyNotesPage.dart';

// Template imports
import 'package:frontend1/templates/BookTracker/booktrackerpage.dart';
import 'package:frontend1/templates/CustomizedPage/home_page0.dart';
import 'package:frontend1/templates/Finance/main0.dart';
import 'package:frontend1/templates/StudyPlannerPage/student_planner2.dart';
import 'package:frontend1/templates/collaboration_template/main_page.dart';
import 'package:frontend1/templates/cv_template/cv_template_section.dart';
import 'package:frontend1/templates/dashboard_template/student_planner.dart';
import 'package:frontend1/templates/internship_template.dart/internship_page.dart';
import 'package:frontend1/templates/page_template/home_page.dart';
import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/AssignmentTracker/chartsCourses.dart';
import 'package:frontend1/templates/Islam/MainIslam.dart';
import 'package:frontend1/templates/Portfolio/AboutMe.dart';
import 'package:frontend1/templates/postgrad_template/post_grad_app.dart';
import 'package:frontend1/templates/Finance/main.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend1/pages/creationFunctions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  
  

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String? email;
  String? userId;
  String? token;

  List<dynamic> userTemplates = [];

  final Map<String, String> manualTemplateTitles = {
    'postgraduate': 'Postgraduate Applications',
    'studentplanner': 'Study Planner',
  //  'project': 'Collaboration Projects',
    'cv': 'Curriculum Vitae (CV)',
    'internship': 'Internship Applications',
    'student_planner': 'Study Planner Dashboard',
    'My Page': 'My Page',
    'Islam': 'Islam',
    'Assignment': 'Assignment',
    'MealsTracker': 'Meals Tracker',
    'Portfolio': 'Portfolio',
    'Book Tracker': 'Book Tracker',
    'Finance': 'Finance',
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchUnreadNotificationCount(); // For the red badge
    await _retrieveUserInfo();
    await _fetchUserTemplates();
  }

  Future<void> _retrieveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token != null) {
      final decodedToken = JwtDecoder.decode(token!);
      setState(() {
        email = decodedToken['email'];
        userId = decodedToken['_id'];
      });
    }
  }

  Future<void> _fetchUserTemplates() async {
    final url = 'http://$localhost/api/template';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userTemplates = data['templates'];
        });
      } else {
        print('Failed to load user templates');
      }
    } catch (error) {
      print('Error fetching user templates: $error');
    }
  }

  Future<List<dynamic>> _fetchSuggestedTemplates() async {
  const url = 'http://$localhost/api/template/suggested';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Filter out templates the user already has
      return data['suggestedTemplates'].where((template) {
        return !userTemplates.any((userTemplate) => userTemplate['type'] == template['id']);
      }).toList();
    } else {
      print('Failed to load suggested templates');
      return [];
    }
  } catch (error) {
    print('Error fetching suggested templates: $error');
    return [];
  }
}


  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Template'),
              content: const Text('Are you sure you want to delete this template?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        )) ??
        false;
  }

  Future<void> _deleteTemplate(String templateId, String templateTitle,String? type) async {
    String endpoint;

    // Known template endpoints
    switch (templateTitle) {
      case 'cv':
        endpoint = 'http://$localhost/api/cv/$templateId';
        break;
      case 'internship':
        endpoint = 'http://$localhost/api/internship/template/$templateId';
        break;
      case 'postgraduate':
        endpoint = 'http://$localhost/api/postgraduate/$templateId';
        break;
      case 'project':
        endpoint = 'http://$localhost/api/project/$templateId';
        break;
      case 'studentplanner':
        endpoint = 'http://$localhost/api/studentplanner/$templateId';
        break;
      case 'student_planner':
        endpoint = 'http://$localhost/api/studentplanner2/$templateId';
        break;
      case 'Book Tracker':
        endpoint = 'http://$localhost/api/booktracker/$templateId';
        break;
      case 'Finance':
        endpoint = 'http://$localhost/api/finance/$templateId';
        break;
      default:
      if(type=="project")
      {
         endpoint = 'http://$localhost/api/project/$templateId';
        break;
      }
        print('Unknown template title: $templateTitle');
        return;
    }

    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userTemplates.removeWhere((t) => t['templateId'] == templateId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Template deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete template.')),
        );
      }
    } catch (error) {
      print('Error deleting template: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while deleting the template.'),
        ),
      );
    }
  }

  /// Navigation to the respective template
  void _navigateToTemplate(String templateTitle, String templateId,String? type) {
    if (templateTitle == "postgraduate") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostgraduateAppPage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "studentplanner") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPlanner2App(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "project") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollaborationPage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "cv") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVEditorScreen(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "student_planner") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPlanner(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "Book Tracker") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookTrackerPage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "internship") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InternshipApplicationsWidget(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "Assignment") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseScreen(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "MealsTracker") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealsMain(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "Islam") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IslamicAppHomePage(token: token!, templateId: templateId),
        ),
      );
    } else if (templateTitle == "Portfolio") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AboutMeScreen(token: token!,templateId: templateId),
        ),
      );
    } else if (templateTitle == "Finance") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mainFinance(token: token!, financeId: templateId),
        ),
      );
    } else {

    if(type=="customPage")  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageScreen(token: token!, templateId: templateId),
        ),
      );
      else 
      {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollaborationPage(token: token!, templateId: templateId),
        ),
      );
      }
    }
  }

  void _refreshUserTemplates() {
    _fetchUserTemplates();
  }

  /// The bottom nav bar with "Browse Templates" & icons
  Widget _footer() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          /*
          // Browse templates button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: 
          
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrowseTemplatesPage(
                      token: token!,
                      onTemplateAdded: _refreshUserTemplates,
                    ),
                  ),
                );
                if (result == true) {
                  _fetchUserTemplates();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey, size: 24),
                    SizedBox(width: 8),
                    Text('Browse templates', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
              */  ////SEARCH
          const Divider(height: 1, color: Colors.grey),
      
          // Bottom navigation icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                const Icon(Icons.home, color: Colors.blue, size: 28),

                // Search
               IconButton(icon:Icon(Icons.search, color: Colors.grey, size: 28),onPressed:()async {
  final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrowseTemplatesPage(
                      token: token!,
                      onTemplateAdded: _refreshUserTemplates,
                    ),
                  ),
                );
                if (result == true) {
                  _fetchUserTemplates();
                }
               },),

                // Notifications / Folder w/badge
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.folder, size: 29, color: Colors.grey),
                      if (NotificationService.unreadMessages > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              NotificationService.unreadMessages.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () async {
                    // Mark all notifications as read
                    await NotificationService.markNotificationsAsRead();
                    setState(() {
                      NotificationService.unreadMessages = 0;
                    });
                    // Go to notifications screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen(token: token!)),
                    );
                  },
                ),

                // Sticky Notes
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            StickyNotesPage(token: token!),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return child; // No transitions
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.edit, color: Colors.grey, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show Locations, Reminders, and Logout in a bottom sheet
  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            runSpacing: 8,
            children: [
            /*  Text(
                'Settings',
                style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              */
              Text(
  'Accounts',
  style: GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 16),
ListTile(
  leading: CircleAvatar(
    backgroundColor: Colors.grey[300],
    child: Icon(Icons.person, color: Colors.black),
  ),
  title: Text(
    email ?? '$email',
    style: GoogleFonts.montserrat(fontSize: 16),
  ),
  trailing: Icon(Icons.check, color: Colors.blue),
),

              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Log out',
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context); // close bottom sheet
                  // Log out the user
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  

  /// Load unread notification count for the badge
  Future<void> fetchUnreadNotificationCount() async {
    final userToken = await NotificationService.retrieveUserToken();
    if (userToken == null) return;

    final url = Uri.parse('http://$localhost/api/unread-count');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        NotificationService.unreadMessages = data['unreadCount'] ?? 0;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching unread notification count: $e');
    }
  }

  Future<void> createCustomPage(String token) async {
    const url = 'http://$localhost/api/custom-page'; // Update with your server URL

    // Data to be sent in the request body
    final Map<String, dynamic> data = {
      'title': 'My Page',
      'BackgroundColor': 4294967295,
      'appBarColor': 4294967295,
      'icon': '📝',
      'toolBarColor': 4294967295,
      'userId': '$userId', // Use retrieved user ID
      'elements': [],
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data), // Convert data to JSON format
      );

      // Check response status
      if (response.statusCode == 201) {
        // Successful creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom page created successfully!')),
        );
        _fetchUserTemplates(); // Refresh the user's templates
      } else {
        // Failed to create custom page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create custom page.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while creating the page.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showSettingsSheet(context),
              child: Row(
                children: [
                  Text(
                    "${email?.split('@')[0]}'s Planly",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ],
              ),
            ),
            Text(
              email ?? 'Loading...',
              style: GoogleFonts.montserrat(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
         leading: Builder(
          builder: (context) {
            return  IconButton(
                     icon: const Icon(Icons.menu),
                     onPressed: () {
                       Scaffold.of(context).openDrawer();
                     },
                   );
                
           },
         ),
      ),
     drawer: Drawer(
               child: _buildDrawerContent(),
             ),

      /// Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SUGGESTED TEMPLATES + `+` BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suggested Templates',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
             /*   IconButton(
                  onPressed: () {
                    if (token != null) {
                      createCustomPage(token!); // Use the retrieved token
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token is missing. Please log in again.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.blue),
                  tooltip: 'Create Custom Page',
                ),
                */
              ],
            ),
          ),
          _suggestedTemplatesSection(),
          const Divider(),

        /// USER TEMPLATES
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Templates',
            style: GoogleFonts.montserrat(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
                  
         /* // Browse templates button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: 
          
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrowseTemplatesPage(
                      token: token!,
                      onTemplateAdded: _refreshUserTemplates,
                    ),
                  ),
                );
                if (result == true) {
                  _fetchUserTemplates();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey, size: 24),
                    SizedBox(width: 8),
                    Text('Browse templates', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
       */ //SEARCH
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: userTemplates.length,
            itemBuilder: (context, index) {
              final template = userTemplates[index];
              final templateTitle = manualTemplateTitles[template['title']] ??
                  template['title'] ??
                  'Untitled';

              return Dismissible(
                key: Key(template['templateId']),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await _showDeleteConfirmationDialog(context);
                },
                onDismissed: (direction) async {
                  // Some templates have custom deletion logic:
                  if (template['title'] == 'My Page') {
                    // Custom page
                    await functionServices.deleteCustomPage(template['templateId'], token!);
                    setState(() {
                      userTemplates.removeWhere(
                        (t) => t['templateId'] == template['templateId'],
                      );
                    });
                  } else if (template['title'] == 'Islam' ||
                      template['title'] == 'Assignment' ||
                      template['title'] == 'MealsTracker') {
                    // Use generic delete from snippet #1
                    await functionServices.deleteTemplate(template['templateId'], token!);
                    setState(() {
                      userTemplates.removeWhere(
                        (t) => t['templateId'] == template['templateId'],
                      );
                    });
                  } else if (template['title'] == 'Portfolio') {
                    await functionServices.deletePortfolio(template['templateId'], token!);
                    setState(() {
                      userTemplates.removeWhere(
                        (t) => t['templateId'] == template['templateId'],
                      );
                    });
                  } else {
                    // Otherwise, call the standard delete
                    await _deleteTemplate(template['templateId'], template['title'],template['type']);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$templateTitle deleted!')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: Text(
                      template['icon'] ?? '📄',
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(
                      templateTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                    onTap: () => {

                      _navigateToTemplate(template['title'], template['templateId'],template['type']),}
                  ),
                ),
              );
            },
          ),
          
        ),

        /// FOOTER (BROWSE + BOTTOM NAV)
        _footer(),
      ],
    ),
    
  floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 80.0), // Adjust bottom padding as needed
    child: FloatingActionButton(
      onPressed: () {
    if (token != null) {
                      createCustomPage(token!); // Use the retrieved token
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token is missing. Please log in again.')),
                      );
                    }
      },
      
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add,color: Colors.white,),
      tooltip: 'Add New Template',
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);
}

 Widget _suggestedTemplatesSection() {
  return FutureBuilder<List<dynamic>>(
    future: _fetchSuggestedTemplates(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Failed to load suggested templates');
      } else if (snapshot.data!.isEmpty) {
        return SizedBox(); // Show nothing if no suggestions
      } else {
        final templates = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: templates.map((template) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the specific template creation page
                  _navigateToTemplate(template['id'], '','');
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          template['image'],
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          template['name'],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    },
  );
}

Widget _buildDrawerContent() {
  final isWeb = MediaQuery.of(context).size.width > 1200;
  return Theme(
    data: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    child: Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (!isWeb)
            Container(
              height: 120,
              color: Colors.blue,
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Locations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add),
            title: const Text('Reminders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderScreen1()),
              );
            },
          ),
       
        ],
      ),
    ),
  );
}

}

