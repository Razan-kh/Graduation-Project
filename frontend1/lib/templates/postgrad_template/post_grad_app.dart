import 'package:flutter/material.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'todo_list_widget.dart';
import 'university_widget.dart';
import 'documentation.dart';
import 'recommendation_letters.dart';
import 'decision_tracking.dart';
import 'package:google_fonts/google_fonts.dart';

class PostgraduateAppPage extends StatefulWidget {
  final String token;
  final String templateId;

  const PostgraduateAppPage({super.key, required this.token, required this.templateId});

  @override
  _PostgraduateAppPageState createState() => _PostgraduateAppPageState();
}

class _PostgraduateAppPageState extends State<PostgraduateAppPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs for simplicity
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg',
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFirstTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TodoListWidget(token: widget.token, templateId: widget.templateId),
        Divider(color: Colors.grey[300], thickness: 1),
        UniversityApplicationsWidget(token: widget.token, templateId: widget.templateId),
        Divider(color: Colors.grey[300], thickness: 1),
        DocumentsSection(token: widget.token, templateId: widget.templateId),
      ],
    );
  }

  Widget _buildSecondTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecommendationLettersWidget(token: widget.token, templateId: widget.templateId),
        Divider(color: Colors.grey[300], thickness: 1),
        DecisionTrackingWidget(token: widget.token, templateId: widget.templateId),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '🎓 Postgraduate Applications',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate directly to DashboardPage, clearing previous pages in the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (route) => false,
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: 'Initial Steps'),
            Tab(text: 'Further Steps'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildFirstTabContent(),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSecondTabContent(),
              ],
            ),
          ),
          
        ],
      ),
       bottomNavigationBar: _footer(), 
    );

    
  }
}
  Widget _footer() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.grey, size: 28),
            Icon(Icons.search, color: Colors.grey, size: 28),
            Icon(Icons.folder, color: Colors.grey, size: 28),
            Icon(Icons.edit, color: Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }

