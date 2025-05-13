import 'package:flutter/material.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/templates/navBar.dart';


class MyApppp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApppp> {
  int selectedSidebarIndex = 0;
  int selectedNavbarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            // Sidebar
            WebSidebar(
             
            ),
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top Navigation Bar
                  WebNavbar(),
                  // Content
                  Expanded(
                    child: Center(
                      child: Text(
                        "Content for ${selectedSidebarIndex == 0 ? "Dashboard" : "Other Page"}",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebSidebar extends StatefulWidget {
  @override
  _WebSidebarState createState() => _WebSidebarState();
}

class _WebSidebarState extends State<WebSidebar> {
  int _selectedIndex = 0; // Tracks the index of the selected tile

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo Section
          
          Container(
            height: 150,
            color: Colors.grey[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Planly",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Sidebar Items Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SidebarTile(
                  icon: Icons.home,
                  title: "Dashboard",
                  isSelected: _selectedIndex == 0,
                  onTap: () => {
                    Navigator.push(context,
                    MaterialPageRoute(builder:(context)=> DashboardPage())),
                    _onTilePressed(0)
                    },
                ),
                SidebarTile(
                  icon: Icons.search,
                  title: "Search",
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onTilePressed(1),
                ),
                SidebarTile(
                  icon: Icons.folder,
                  title: "Notifications",
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onTilePressed(2),
                ),
                SidebarTile(
                  icon: Icons.note,
                  title: "Notes",
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onTilePressed(3),
                ),
              
                SidebarTile(
                  icon: Icons.logout,
                  title: "Logout",
                  isSelected: _selectedIndex == 5,
                  onTap: () => _onTilePressed(5),
                ),
              ],
            ),
          ),
          // Footer Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "© 2025 Planly",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTilePressed(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }
}

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  SidebarTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.blue : Colors.transparent,
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[700],
            size: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
