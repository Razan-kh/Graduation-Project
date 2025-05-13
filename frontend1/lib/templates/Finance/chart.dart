import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For the chart
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/MealsTracker/MealModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class DailyNetChartScreen extends StatefulWidget {
  final String financeId;
  final double net;
  DailyNetChartScreen({required this.financeId, required this.net});
  @override
  _DailyNetChartScreenState createState() => _DailyNetChartScreenState();
}

class _DailyNetChartScreenState extends State<DailyNetChartScreen> {
  final DailyNetService _dailyNetService =
      DailyNetService('http://$localhost/api');
  List<ChartData> _chartData = [];
  List<ChartData> _chartYear = [];
  List<ChartData> _expensesMonth = [];
  List<ChartData> _IncomesMonth = [];

List<ChartData> expensesChartData = [
  ChartData(day: 1, net: 15.99),
  ChartData(day: 2, net: 20.99),
  ChartData(day: 3, net: 31.49),
  ChartData(day: 4, net: 51.49),
  ChartData(day: 5, net: 51.49),
  ChartData(day: 6, net: 63.49),
  ChartData(day: 7, net: 71.49),
  ChartData(day: 8, net: 76.49),
  ChartData(day: 9, net: 96.49),
  ChartData(day: 10, net: 246.49),
  ChartData(day: 11, net: 261.49),
  ChartData(day: 12, net: 261.49),
  ChartData(day: 13, net: 261.49),
  ChartData(day: 14, net: 261.49),
  ChartData(day: 15, net: 261.49),
  ChartData(day: 16, net: 261.49),
  ChartData(day: 17, net: 261.49),
  ChartData(day: 18, net: 266.49),
  ChartData(day: 19, net: 266.49),
  ChartData(day: 20, net: 266.49),
  ChartData(day: 21, net: 266.49),
  ChartData(day: 22, net: 266.49),
  ChartData(day: 23, net: 266.49),
  ChartData(day: 24, net: 266.49),
  ChartData(day: 25, net: 271.49),
  ChartData(day: 26, net: 271.49),
  ChartData(day: 27, net: 271.49),
  ChartData(day: 28, net: 271.49),
  ChartData(day: 29, net: 271.49),
  ChartData(day: 30, net: 271.49),
  ChartData(day: 31, net: 271.49),
];

List<Map<String, dynamic>> chartData = [
  {"day": 1, "net": 784.01},
  {"day": 2, "net": 1568.02},
  {"day": 3, "net": 2352.03},
  {"day": 4, "net": 3131.04},
  {"day": 5, "net": 3910.05},
  {"day": 6, "net": 4689.06},
  {"day": 7, "net": 5468.07},
  {"day": 8, "net": 6247.08},
  {"day": 9, "net": 7022.09},
  {"day": 10, "net": 7647.10},
  {"day": 11, "net": 8257.11},
  {"day": 12, "net": 8867.12},
  {"day": 13, "net": 9477.13},
  {"day": 14, "net": 10087.14},
  {"day": 15, "net": 10697.15},
  {"day": 16, "net": 11307.16},
  {"day": 17, "net": 11917.17},
  {"day": 18, "net": 12522.18},
  {"day": 19, "net": 13127.19},
  {"day": 20, "net": 13732.20},
  {"day": 21, "net": 14337.21},
  {"day": 22, "net": 14942.22},
  {"day": 23, "net": 15547.23},
  {"day": 24, "net": 16152.24},
  {"day": 25, "net": 16752.25},
  {"day": 26, "net": 17352.26},
  {"day": 27, "net": 17952.27},
  {"day": 28, "net": 18552.28},
  {"day": 29, "net": 19152.29},
  {"day": 30, "net": 19752.30},
  {"day": 31, "net": 20352.31},
];

List<ChartData> incomesDefault = [
  ChartData(day: 1, net: 784.01),
  ChartData(day: 2, net: 784.01),
  ChartData(day: 3, net: 784.01),
  ChartData(day: 4, net: 784.01),
  ChartData(day: 5, net: 784.01),
  ChartData(day: 6, net: 784.01),
  ChartData(day: 7, net: 784.01),
  ChartData(day: 8, net: 784.01),
  ChartData(day: 9, net: 784.01),
  ChartData(day: 10, net: 784.01),
  ChartData(day: 11, net: 784.01),
  ChartData(day: 12, net: 784.01),
  ChartData(day: 13, net: 784.01),
  ChartData(day: 14, net: 784.01),
  ChartData(day: 15, net: 784.01),
  ChartData(day: 16, net: 784.01),
  ChartData(day: 17, net: 784.01),
  ChartData(day: 18, net: 784.01),
  ChartData(day: 19, net: 784.01),
  ChartData(day: 20, net: 784.01),
  ChartData(day: 21, net: 784.01),
  ChartData(day: 22, net: 784.01),
  ChartData(day: 23, net: 784.01),
  ChartData(day: 24, net: 784.01),
  ChartData(day: 25, net: 784.01),
  ChartData(day: 26, net: 784.01),
  ChartData(day: 27, net: 784.01),
  ChartData(day: 28, net: 784.01),
  ChartData(day: 29, net: 784.01),
  ChartData(day: 30, net: 784.01),
  ChartData(day: 31, net: 784.01),
];

  bool _isLoading = true;
  int _selectedIndex = 0;
  //   bool _selectedIndex1 = 0;
  //   bool _selectedIndex2 = 0;
  int _selectedIndex3 = 0;

  DateTime today = DateTime.now(); // Get the current date and time
  int daysGone = 10;
  int monthsGone = 1;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
    daysGone = today.day;
    monthsGone = today.month;
  }

  Future<void> _fetchChartData() async {
    try {
      final data =
          await _dailyNetService.fetchDailyNet(widget.financeId, 2025, 0);
      final yearData =
          await _dailyNetService.fetchYearNet(widget.financeId, 2025);
      final MonthExpense = await _dailyNetService.fetchMonthlyExpenses(
          widget.financeId, 0, 2025);
      final MonthIncomes =
          await _dailyNetService.fetchMonthlyIncomes(widget.financeId, 0, 2025);

      setState(() {
        _chartData = data;
        _chartYear = yearData;
      //  _expensesMonth = MonthExpense;
        _IncomesMonth = MonthIncomes;
      //  print(_chartYear);
      print("month data is");
        print(_chartData);
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load chart data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(1.0),
                /*  appBar: AppBar(
        title: Text('Finance Details'),
      ),
      */
                //   child: SingleChildScrollView(
                //child : //_isLoading ? CircularProgressIndicat

                child: Column(
                  children: [
                    Container(
                      child: // Text("Total Money per Year "),
                          ToggleButtons(
                        isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                        onPressed: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        children: const [
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Month Chart')),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Year Chart')),
                        ],
                      ),
                    ),
/*
Row(
  children: [
    CheckboxListTile(
      title: Text("Expenses"),
      value: _selectedIndex1,
      onChanged: (bool? value) {
        setState(() {
         // _selectedIndex1 = value == true ? 0 : -1;
         _selectedIndex1=value;
        });
      },
    ),
    CheckboxListTile(
      title: Text("Incomes"),
      value: _selectedIndex2,
      onChanged: (bool? value) {
        setState(() {
        //  _selectedIndex2 = value == true ? 1 : -1;
        _selectedIndex2=value;
        });
      },
    ),
  ],
)
*/
                    Container(
                      child: // Text("Total Money per Year "),
                          ToggleButtons(
                        isSelected: [
                          _selectedIndex3 == 0,
                          _selectedIndex3 == 1,
                          _selectedIndex3 == 2
                        ],
                        onPressed: (index) {
                          setState(() {
                            _selectedIndex3 = index;
                          });
                        },
                        children: const [
                          Padding(
                              padding: EdgeInsets.all(8.0), child: Text('Net')),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Expenses')),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Incomes')),
                        ],
                      ),
                    ),
                    Expanded(
                      //   padding: const EdgeInsets.all(16.0),
                      // height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _selectedIndex == 0
                            ? _selectedIndex3 == 0
                                ? monthChart(_chartData)
                                : _selectedIndex3 == 1
                                    ? monthChart(expensesChartData)
                                    : monthChart(incomesDefault)
                            : YearChart(),
/*
  List<ChartData> _chartData = [];
    List<ChartData> _expensesMonth=[];
        List<ChartData> _IncomesMonth=[];
*/
                      ),
                    ),
                  ],
                ))
        //   )
        );
  }

  Widget monthChart(List<ChartData> data0) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data0
                .where((data) =>
                    data.day <= 15) // Only include data up to the current day
                .map((data) => FlSpot(data.day.toDouble(), data.net))
                .toList(),
            isCurved: true,
            barWidth: 4,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5, // Titles at intervals of 5 days
              getTitlesWidget: (value, meta) {
                if (value >= 1 && value <= 30) {
                  return Text(
                      value.toInt().toString()); // Show days from 1 to 30
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // Disable top X-axis
          rightTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false)), // Disable right Y-axis
        ),
        borderData: FlBorderData(show: true),
        minY: 0, // Y-axis starts at 0
        maxX: 31, // X-axis shows up to 30 days
      ),
    );
  }

  Widget YearChart() {
    final int monthsGone =
        DateTime.now().month; // Get the current month (1 to 12)

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: _chartYear
                .where((data) =>
                    data.day <= 1) // Only include data up to the current day
                .map((data) => FlSpot(data.day.toDouble(), data.net))
                .toList(),
            isCurved: true,
            barWidth: 4,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // Titles at intervals of 5 days

              getTitlesWidget: (value, meta) {
                if (value >= 1 && value <= 12) {
                  return Text(
                      value.toInt().toString()); // Show days from 1 to 30
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // Disable top X-axis
          rightTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false)), // Disable right Y-axis
        ),
        borderData: FlBorderData(show: true),
        minY: 0,
        maxY: 5000, // Y-axis starts at 0
        maxX: 12, // X-axis shows up to 30 days
      ),
    );
  }
}

class DailyNetService {
  final String baseUrl;

  DailyNetService(this.baseUrl);

  Future<List<ChartData>> fetchDailyNet(
      String financeId, int year, int month) async {
    try {
      final url = Uri.parse(
          '$baseUrl/daily-net?financeId=$financeId&year=$year&month=$month');
      // Send GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        print("chart data is ${data}");
        // Convert to a list of ChartData objects
        final List<ChartData> chartData = (data['chartData'] as List)
            .map((item) => ChartData(
                day: item['day'], net: (item['net'] as num).toDouble()))
            .toList();

        return chartData;
      } else {
        throw Exception(
            'Failed to load daily net data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching daily net data: $e');
      rethrow;
    }
  }

  Future<List<ChartData>> fetchYearNet(String financeId, int year) async {
    try {
      final url =
          Uri.parse('$baseUrl/get-year-data?financeId=$financeId&year=$year');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("year chart data is ${data}");
        final List<ChartData> chartData = (data['chartData'] as List)
            .map((item) => ChartData(
                day: item['month'], net: (item['net'] as num).toDouble()))
            .toList();

        return chartData;
      } else {
        throw Exception(
            'Failed to load yearly net data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching yearly net data: $e');
      rethrow;
    }
  }

  Future<List<ChartData>> fetchMonthlyExpenses(
      String financeId, int month, int year) async {
    try {
      final response = await http.get(
        Uri.parse('http://$localhost/api/expenses/$financeId/$month/$year'),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<ChartData> chartData = (data['chartData'] as List)
            .map((item) => ChartData(
                day: item['day'], net: (item['net'] as num).toDouble()))
            .toList();

        return chartData;
      } else {
        throw Exception('Failed to load expenses');
      }
    } catch (error) {
      print('Error fetching expenses: $error');
      return [];
    }
  }

  Future<List<ChartData>> fetchMonthlyIncomes(
      String financeId, int month, int year) async {
    try {
      final response = await http.get(
        Uri.parse('http://$localhost/api/incomes/$financeId/$month/$year'),
      );
print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<ChartData> chartData = (data['chartData'] as List)
            .map((item) => ChartData(
                day: item['day'], net: (item['net'] as num).toDouble()))
            .toList();

        return chartData;
      } else {
        throw Exception('Failed to load incomes');
      }
    } catch (error) {
 
      print('Error fetching incomes: $error');
      return [];
    }
  }
}

// Model for chart data
class ChartData {
  final int day;
  final double net;

  ChartData({required this.day, required this.net});
}
