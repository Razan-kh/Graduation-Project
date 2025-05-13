
import 'package:flutter/material.dart';

class WebNavbar extends StatefulWidget {
  @override
  _WebNavbarState createState() => _WebNavbarState();
}

class _WebNavbarState extends State<WebNavbar> {
  int _selectedIndex = 0; // Tracks the selected navigation item

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[900], // Dark background
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo or Brand Name
          Text(
            "Planly",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          Spacer(),
          // Static Navigation Items
          Row(
            children: [
              _buildNavItem("Home", 0),
              _buildNavItem("About", 1),
              _buildNavItem("Services", 2),
              _buildNavItem("Contact", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.white : Colors.white70,
                fontSize: 16,
                fontWeight:
                    _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 4),
            if (_selectedIndex == index)
              Container(
                height: 3,
                width: 20,
                color: Colors.blueAccent, // Underline color for active item
              ),
          ],
        ),
      ),
    );
  }
}