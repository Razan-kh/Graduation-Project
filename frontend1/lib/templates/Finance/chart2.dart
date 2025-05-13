import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class NetIncomeChart extends StatefulWidget {
  @override
  _NetIncomeChartState createState() => _NetIncomeChartState();
}

class _NetIncomeChartState extends State<NetIncomeChart> {
  List<String> months = [];
  List<double> realNetIncome = [];
  List<double> predictedNetIncome = [];
Future<void> fetchNetIncome() async {
  final response = await http.get(Uri.parse(
      'http://192.168.1.19:5000/net-income?finance_id=679925edccf01ca0c631dbf3'));
  print(response.statusCode);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print(data);

    // Ensure data is valid
    if (data == null || data['real_data'] == null || data['real_data'].isEmpty) {
      print("Error: No valid data received.");
      return;
    }

    // Extract real income data up to today
    List<dynamic> realData = data['real_data'];
    List<dynamic> predictedData = data['predicted_data'];

    setState(() {
      // Ensure each entry in realData and predictedData has the expected structure
      months = List<String>.from(realData.map((d) {
        if (d['day'] != null) {
          return 'Day ${d['day']}';
        } else {
          print("Error: Missing day data in realData entry");
          return 'Invalid Day';
        }
      }));

      realNetIncome = List<double>.from(realData.map((entry) {
        if (entry['net'] != null && entry['net'] is num) {
          return (entry['net'] as num).toDouble();
        } else {
          print("Error: Invalid or missing 'net' value in realData entry");
          return 0.0; // default value
        }
      }));

      predictedNetIncome = List<double>.from(predictedData.map((entry) {
        if (entry['net'] != null && entry['net'] is num) {
          return (entry['net'] as num).toDouble();
        } else {
          print("Error: Invalid or missing 'net' value in predictedData entry");
          return 0.0; // default value
        }
      }));
    });
  } else {
    print("Failed to load data: ${response.statusCode}");
  }
}

  @override
  void initState() {
    super.initState();
    fetchNetIncome();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Net Income Chart")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (months.isEmpty || realNetIncome.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            // Wrap the LineChart in a Container with a defined size
            Container(
              height: 300, // Define a height for the chart
              width: double.infinity, // Take up full width of the screen
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: realNetIncome.asMap().entries.map((entry) {
                        int idx = entry.key;
                        double value = entry.value;
                        return FlSpot(idx.toDouble(), value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: predictedNetIncome.asMap().entries.map((entry) {
                        int idx = entry.key + realNetIncome.length;
                        double value = entry.value;
                        return FlSpot(idx.toDouble(), value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      dashArray: [8, 4], // For dashed line
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}
