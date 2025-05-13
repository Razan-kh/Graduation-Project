import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend1/templates/collaboration_template/projects_collaboration.dart';
import 'package:frontend1/templates/collaboration_template/calender.dart';
import 'package:frontend1/templates/collaboration_template/KanbanBoard.dart';
import 'package:frontend1/templates/collaboration_template/addMembers.dart';
import 'package:frontend1/templates/collaboration_template/whiteboard_page.dart';
import 'package:frontend1/templates/collaboration_template/ghantChart.dart';
import 'package:frontend1/templates/collaboration_template/chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:frontend1/templates/sideBar.dart';


class CollaborationPage extends StatefulWidget {
  final String token;
  final String templateId;

  const CollaborationPage({super.key, required this.token, required this.templateId});

  @override
  _CollaborationPageState createState() => _CollaborationPageState();
}

class _CollaborationPageState extends State<CollaborationPage> {
  int selectedIconIndex = 0;
  late List<Widget> pages;
 // String projectTitle = "Loading...";
   final TextEditingController _titleController1 = TextEditingController();
       Timer? _debounce; 
  @override
  void initState() {
    super.initState();
    //  fetchProjectTitle(); // Fetch project title
    fetchTemplateTitle(widget.templateId);
        _titleController1.addListener(_onTextChanged1);
      //  _titleController.text= projectTitle;
    pages = [
      buildHomeContent(),
      WhiteboardPage(token: widget.token, templateId: widget.templateId),
      KanbanBoard(
        token: widget.token,
        templateId: widget.templateId,
        key: ValueKey('KanbanBoard'), // Fixed: Added required key
      ),
      CustomGanttChart(token: widget.token, templateId: widget.templateId),
      AddUsersPage(token: widget.token, templateId: widget.templateId),
    ];
  }

  void _onTextChanged1() {
    // Debouncing logic to wait 1 second after the user stops typing
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(seconds: 1), () {
   //   _saveChangesToBackend();
   updateTemplateTitlee(templateId:  widget.templateId,newTitle: _titleController1.text);
    });
  }


Future<void> updateTemplateTitlee({
  required String templateId,
  required String newTitle,
}) async {
  final url = Uri.parse('http://$localhost/api/templates/$templateId'); // Replace with your API URL

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': newTitle,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Template updated successfully: ${responseData['message']}');
    } else {
      print('Failed to update template: ${response.body}');
    }
  } catch (e) {
    print('Error updating template: $e');
  }
}
/*
Future<void> fetchProjectTitle() async {
  print("Fetching project title...");
  final url = Uri.parse("http://$localhost/api/project-templates/${widget.templateId}");

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}', // Send token for authentication
      },
    );

    print("Response Status Code (Title): ${response.statusCode}");
    print("Response Body (Title): ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('title')) {
        setState(() {
        //  projectTitle = data['title'];
        _titleController1.text=data['title'];
        });
      } else {
        throw Exception("Invalid response format for project title");
      }
    } else {
      throw Exception("Failed to load project title: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error fetching project title: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching project title')),
    );
  }
}
*/

Future<void> fetchTemplateTitle(String templateId) async {
  final url = Uri.parse('http://$localhost/api/templates/$templateId/title'); // Replace with your API URL

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
             _titleController1.text= data['title']; // Return the template title

      });
    } else if (response.statusCode == 404) {
      print('Template not found.');
  
    } else {
      print('Failed to fetch template: ${response.body}');
   
    }
  } catch (e) {
    print('Error fetching template title: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
        bool isWeb=MediaQuery.of(context).size.width>1200? true: false;

    return Scaffold(
      appBar: AppBar(
              automaticallyImplyLeading: false, 
        leading: IconButton(onPressed: (){
           Navigator.push(
        context,
        MaterialPageRoute(
           builder: (context) => DashboardPage(),
        ),
      );
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: [
            
    Expanded(
      child: TextField(
        controller: _titleController1,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    ),
        /*
            Text(
              'Projects and Tasks',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            */
          //  Spacer(),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.black),
              onPressed: _openChatPopup,
            ),
            IconButton(
              icon: Icon(Icons.video_call, color: Colors.black),
              onPressed: _openZoomPopup,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
       SafeArea(
         child:  Row(
  children: [
      if (isWeb) WebSidebar(),
    if (isWeb) SizedBox(width: 100), // Spacer for web layout
   Expanded(
          flex: 5, // Adjust flex to allocate space proportionally
  
        child: Column(
          children: [
            // Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://static.vecteezy.com/system/resources/previews/025/410/421/non_2x/project-management-team-collaboration-task-delegation-concept-with-character-project-execution-abstract-illustration-set-timelines-milestones-project-success-metaphor-vector.jpg',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            // Navigation Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavigationIcon(Icons.home, 0),
                buildNavigationIcon(Icons.draw, 1),
                buildNavigationIcon(Icons.task, 2),
                buildNavigationIcon(Icons.bar_chart, 3),
                buildNavigationIcon(Icons.group_add, 4),
              ],
            ),
            // Main Content Area
            Expanded(
              child: IndexedStack(
                index: selectedIconIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
          if (isWeb) SizedBox(width: 100), // Spacer for web layout

  ]
         )
         
       )
    );
  }

  Widget buildNavigationIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIconIndex == index ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          selectedIconIndex = index;
        });
      },
    );
  }

  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Tasks Page
          SizedBox(
            height: 700, // Fixed height constraint
            child: ProjectTasksPage(
              token: widget.token,
              templateId: widget.templateId,
            ),
          ),
          Divider(color: Colors.grey),
          // Calendar Widget
          SizedBox(
            height: 300, // Fixed height constraint
            child: CalendarWidget1(
              token: widget.token,
              templateId: widget.templateId,
            ),
          ),
        ],
      ),
    );
  }

  void _openChatPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ChatScreen(templateId: widget.templateId),
      ),
    );
  }

  void _openZoomPopup() async {
    await createAndLaunchZoomMeeting();
  }

  Future<void> createAndLaunchZoomMeeting() async {
    try {
      final response = await http.post(
        Uri.parse('http://$localhost/api/zoom/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'topic': 'Flutter Test Meeting',
          'start_time': DateTime.now().add(Duration(minutes: 10)).toIso8601String(),
          'duration': 30,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String meetingUrl = responseData['meeting_url'];
        Uri uri = Uri.parse(Uri.encodeFull(meetingUrl));

        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $meetingUrl');
        }
      } else {
        print('Failed to create meeting: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
