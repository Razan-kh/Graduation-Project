import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/footer.dart';
import 'package:frontend1/templates/Finance/buttons.dart';
import 'package:frontend1/templates/Finance/chart1.dart';
import 'package:frontend1/templates/Finance/classes/finance.dart';
import 'package:frontend1/templates/Finance/dropDownMenues.dart';
import 'package:frontend1/templates/Finance/incomes.dart';
import 'package:frontend1/templates/Finance/main.dart';
import 'package:frontend1/templates/Finance/python.dart';
import 'package:frontend1/templates/Finance/subscriptions.dart';
import 'package:frontend1/templates/Finance/chart.dart';
import 'package:frontend1/templates/Finance/chart2.dart';
import 'package:frontend1/templates/Finance/toolTip.dart';
import 'package:frontend1/templates/navBar.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class mainFinance extends StatefulWidget {
    final String financeId;
  final String token;
  mainFinance({required this.financeId, required this.token});

  @override
  mainFinanceState createState()=> mainFinanceState();
}
class mainFinanceState extends State<mainFinance> {
  int _selectedIndex = 0;
late  List<Widget> _pages=[];
late Finance finance;
bool isLoading=true;
@override
void initState()
{
  super.initState();
fetchFinanceById(widget.financeId);
}

Future<void> fetchFinanceById(String id) async {
    try {
      final response =
          await http.get(Uri.parse('http://$localhost/api/finances/$id'));

      if (response.statusCode == 200) {
        setState(() {
        

              final Map<String, dynamic> data = json.decode(response.body);
print("data is $data");

  finance = Finance.fromJson(data);
_pages = [
  FinancePage(financeId: widget.financeId,finance:finance,token:widget.token ),
   IncomePage(finance: finance,),
SubscriptionList(finance:finance ),
     DailyNetChartScreen(financeId:finance.id,net: finance.net,),
  //   NetIncomeChart(),
  //FinancialChartPage()
  //FinanceForecastPage()
  ];

       //  print(" ${_finance.subscriptions }  ${_finance.incomes}  ${_finance.net}  ${_finance.bills[0].name}  ${_finance.categories[0].id}");
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load finance with ID: $id');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        print("error is $error");
       // _hasError = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600; // Simple web check

    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                if (isWeb) WebSidebar(), 
                if (isWeb)   SizedBox(width:100), 
               
                Expanded(
                  child: Column(
                    children: [
                    /*  if (isWeb)
                        WebNavbar(), 
                        */// Add the navbar for web layout
                      if (!isWeb)
                        AppBar(
                                automaticallyImplyLeading: false, 
                          title: Text("Finance"),
                          actions: [
                            IconButton(
                              onPressed: () => _showNetDialog(context),
                              icon: Text(
                                "💲",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ) as PreferredSizeWidget,
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://t4.ftcdn.net/jpg/01/50/57/35/360_F_150573568_o8W7vQCPue3vxYiokBLCQvAvsGsMzq2e.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.home),
                                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                                  onPressed: () => setState(() => _selectedIndex = 0),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                                  onPressed: () => setState(() => _selectedIndex = 1),
                                ),
                                IconButton(
                                  icon: Icon(Icons.event_available),
                                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                                  onPressed: () => setState(() => _selectedIndex = 2),
                                ),
                                IconButton(
                                  icon: Icon(Icons.bar_chart),
                                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = 3;
                                    });
                                    fetchFinanceById(widget.financeId);
                                  },
                                ),
                                  IconButton(
                                  icon: Icon(Icons.event_available),
                                  color: _selectedIndex == 4 ? Colors.blue : Colors.grey,
                                  onPressed: () => setState(() => _selectedIndex = 4),
                                ),
                              ],
                            ),
                            Expanded(
                              child: _pages.isNotEmpty
                                  ? _pages[_selectedIndex]
                         
                                  : Center(child: Text("No Content Available")),
                            ),
                   if(!isWeb)    _footer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                  if (isWeb) SizedBox(width:100), 
              ],
            ),
      )
    );
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

  void _showNetDialog(BuildContext context) {
   double _netAmount=finance.net;
    final TextEditingController netController = TextEditingController(
      text: _netAmount?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _netAmount == null ? "Enter Initial Net" : "Enter Initial Amount",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: netController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter amount",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",style: TextStyle(color: Colors.blue),),
            ),
            ElevatedButton(
              
              onPressed: () {
                final enteredValue = double.tryParse(netController.text);
                if (enteredValue != null) {
           updateNet(enteredValue);
                  Navigator.pop(context);
                } else {
                  // Show error if invalid number
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid number")),
                  );
                }
              },
              child: Text(_netAmount == null ? "Save" : "Update",style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }



Future<void> updateNet( double newNet) async {
  String financeId=finance.id;
  final String baseUrl = 'http://$localhost/api'; // Replace with your API base URL
  final String endpoint = '/finance/$financeId/net';

  try {
    // Construct the request URL
    final Uri url = Uri.parse('$baseUrl$endpoint');

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'net': newNet,
    };

    // Make the PUT request
    final http.Response response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Net updated successfully: ${data['data']}');
    } else {
      final error = jsonDecode(response.body);
      print('Failed to update net: ${error['message']}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

}