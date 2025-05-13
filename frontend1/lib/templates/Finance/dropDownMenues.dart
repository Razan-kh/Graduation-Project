import 'package:flutter/material.dart';

class ChartSelectorPage extends StatefulWidget {
  @override
  _ChartSelectorPageState createState() => _ChartSelectorPageState();
}

class _ChartSelectorPageState extends State<ChartSelectorPage> {
  // Variables to store user selections
  String? selectedMonth;
  int? selectedYear;
  String chartType = 'Month'; // Default chart type

  // Data for dropdowns
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<int> years = List.generate(20, (index) => 2020 + index); // Generate years from 2020 to 2039

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Selector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting the month
            Text(
              'Select Month:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedMonth,
              hint: Text('Choose a month'),
              items: months.map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Dropdown for selecting the year
            Text(
              'Select Year:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedYear,
              hint: Text('Choose a year'),
              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Toggle buttons for chart type
            Text(
              'Chart Type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ChoiceChip(
                  label: Text('Month'),
                  selected: chartType == 'Month',
                  onSelected: (isSelected) {
                    setState(() {
                      chartType = 'Month';
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text('Year'),
                  selected: chartType == 'Year',
                  onSelected: (isSelected) {
                    setState(() {
                      chartType = 'Year';
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 40),

            // Displaying the selections
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMonth == null || selectedYear == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select both month and year.')),
                    );
                  } else {
                    print('Selected Month: $selectedMonth');
                    print('Selected Year: $selectedYear');
                    print('Chart Type: $chartType');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selections saved!')),
                    );
                  }
                },
                child: Text('Show Chart Selections'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}