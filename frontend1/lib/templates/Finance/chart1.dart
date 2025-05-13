import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class FinancialChartPage extends StatefulWidget {
  @override
  _FinancialChartPageState createState() => _FinancialChartPageState();
}

class _FinancialChartPageState extends State<FinancialChartPage> {
  List<String> months = [];
  List<double> realNetIncome = [];
  List<double> predictedNetIncome = [];

  // Fetch the data from the API
  Future<void> fetchNetIncome() async {
    final response = await http.get(Uri.parse('http://192.168.1.19:5000/api/net-income'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
     setState(() {
      months = List<String>.from(data['real_data']['months']);
      realNetIncome = List<double>.from(
        data['real_data']['net_income'].map((x) => x.toDouble()),
      );
      predictedNetIncome = List<double>.from(
        data['predicted_data']['net_income'].map((x) => x.toDouble()),
      );
    });
    } else {
      throw Exception('Failed to load data');
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
      appBar: AppBar(title: Text('Net Income Over the Year')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: months.isEmpty
            ? Center(child: CircularProgressIndicator())
            : LineChart(
  LineChartData(
    gridData: FlGridData(show: true),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < months.length) {
              return Text(months[index]);
            } else {
              return const SizedBox();
            }
          },
          reservedSize: 22,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(value.toStringAsFixed(0));
          },
          reservedSize: 40,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.black, width: 1),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: [
          ...List.generate(realNetIncome.length,
              (index) => FlSpot(index.toDouble(), realNetIncome[index])),
          ...List.generate(predictedNetIncome.length,
              (index) => FlSpot(
                  (index + realNetIncome.length).toDouble(),
                  predictedNetIncome[index]))
        ],
        isCurved: true,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green], // Transition from blue to green
          stops: [0.6, 1.0], // Adjust transition point
        ),
      ),
    ],
  ),
),


              
      ),
    );
  }
}
