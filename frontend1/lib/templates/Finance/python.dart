import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class FinanceForecastPage extends StatefulWidget {
  @override
  _FinanceForecastPageState createState() => _FinanceForecastPageState();
}

class _FinanceForecastPageState extends State<FinanceForecastPage> {
  List<String> forecastDates = [];
  List<double> arimaExpenses = [];
  List<double> arimaIncomes = [];
  List<double> lstmExpenses = [];
  List<double> lstmIncomes = [];

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<void> fetchForecast() async {
    print("hi");
    final response = await http.get(Uri.parse('http://192.168.1.19:5000/predict'));
          print("status code is ${response.statusCode}");

   // if (response.statusCode == 200) {
      final data = json.decode(response.body);
         print(data);
      setState(() {
        forecastDates = List<String>.from(data["dates"]);
        arimaExpenses = List<double>.from(data["arima_expenses"]);
        arimaIncomes = List<double>.from(data["arima_incomes"]);
        lstmExpenses = List<double>.from(data["lstm_expenses"]);
        lstmIncomes = List<double>.from(data["lstm_incomes"]);
      });
  //  }
  }

  Widget buildChart(List<double> data, Color color) {
     
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index]),
            ),
            isCurved: true,
           // colors: [color],
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Finance Forecast")),
      body: Column(
        children: [
          Text("ARIMA Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 200, child: buildChart(arimaExpenses, Colors.blue)),
          Text("LSTM Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 200, child: buildChart(lstmExpenses, Colors.red)),
        ],
      ),
    );
  }
}
