import 'package:flutter/material.dart';

class ChartSelector extends StatefulWidget {
  @override
  _ChartSelectorState createState() => _ChartSelectorState();
}

class _ChartSelectorState extends State<ChartSelector> {
  int _selectedIndex = 0; // 0 for Line Chart, 1 for Bar Chart

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [_selectedIndex == 0, _selectedIndex == 1],
          onPressed: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const [
            Padding(padding: EdgeInsets.all(8.0), child: Text('Line Chart')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('Bar Chart')),
          ],
        ),
        /*
        _selectedIndex == 0
            ? //LineChartWidget() // Replace with your Line Chart widget
            : //BarChartWidget(), // Replace with your Bar Chart widget
            */
      ],
    );
  }
}
