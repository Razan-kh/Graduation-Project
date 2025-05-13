import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Finance/classes/finance.dart';
import 'package:frontend1/templates/Finance/classes/subscription.dart';
  import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionList extends StatefulWidget {
Finance finance;
  SubscriptionList({required this.finance});
  @override
  SubscriptionListState createState() =>SubscriptionListState();
}
class SubscriptionListState extends State<SubscriptionList> {
  late  final List<Subscription> subscriptions;
  @override 
  void initState()
  {
    super.initState();
subscriptions=widget.finance.subscriptions;

  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
print("screen width is :$width");
 return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Scaffold(

      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: 
 TextButton(onPressed: ()async {
 final result = await showDialog(
    context: context,
    builder: (context) => SubscriptionPopup(),
  );

  if (result != null && result is Map) {
   // print("Category Name: ${result['name']}");
  //  print("Category Icon: ${result['type']}");
    print("Category Description: ${result}");
   // addCategory(result['name'],result['description'],result['icon'],);
   Map<String,dynamic> incomeData={
'name' :result['name'],
'notes':result['description'],
'amount':result['amount'],
'type':result['type'],
'renewalDate': result['renewalDate']
   };
//addIncomeToFinance(widget.finance.id, incomeData);
addSubscriptionToFinance(financeId: widget.finance.id, name: result['name'], amount: result['amount'], renewalDate: result['renewalDate'], frequency: result['type'],notes: result['description']);


  }
      }, child: Text("Add Subscription",style: TextStyle(color: Colors.blue),)),
           ),
       
      CarouselSlider.builder(
        itemCount: subscriptions.length,
        itemBuilder: (context, index, realIndex) {
          final subscription = subscriptions[index];
           DateTime renewalDate = (subscription.renewalDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(renewalDate!);
bool isWeb=MediaQuery.of(context).size.width>600? true:false;
          return Container(
           // width:isWeb? 400:200 ,
           // height: 200,
           height: 50,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
           decoration: BoxDecoration(
            
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
              
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subscription.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Renewal Date: ${(formattedDate              )}'),
                Text('Amount: \$${subscription.amount}'),
                Text('Status: ${subscription.status}'),
              ],
            ),
          );
        },
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          height: 250,
          enableInfiniteScroll:false
        ),
      ),
       ],
      )
      )
    );
  }



Future<void> addSubscriptionToFinance({
  required String financeId,
  required String name,
  required double amount,
  required String renewalDate,
  required String frequency,

  String? category,
  String? notes,
}) async {
  final String apiUrl = 'http://$localhost/api/finances/$financeId/subscriptions'; // Replace with your backend URL

  final Map<String, dynamic> subscriptionData = {
    'name': name,
    'amount': amount,
    'renewalDate': renewalDate,
    'frequency': frequency,

    'category': category,
    'notes': notes,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(subscriptionData),
    );

    if (response.statusCode == 201) {
      print('Subscription added successfully: ${response.body}');
      final desodedData=json.decode(response.body);
      Subscription newSubscription =Subscription.fromJson(desodedData['subscription']);
      setState(() {
             subscriptions.add(newSubscription);
      });
 

    } else {
      print('Failed to add subscription: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    print('Error occurred while adding subscription: $e');
  }
}

}


 class SubscriptionPopup extends StatefulWidget {
  @override
 SubscriptionPopupState createState() => SubscriptionPopupState();
}
/*
 required this.name,
    required this.amount,
    required this.renewalDate,
    required this.frequency,
    required this.status,
    this.notes,*/

class SubscriptionPopupState extends State<SubscriptionPopup> {
     final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

  String? _selectedEmoji;
 Widget build(BuildContext context) {
  String? selectedType = "Monthly"; // Default value for the dropdown

  final TextEditingController _renewalDateController = TextEditingController();

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text("Add Subscription"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Subscription Name",
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Category Notes",
                ),
              ),
             
              
              SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [ "Monthly", "Weekly", "Yearly",]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                   
                  });
                },
                decoration: InputDecoration(
                  labelText: "Type",
                ),
              ),
              SizedBox(height: 16),
        
                TextField(
                  controller: _renewalDateController,
                  readOnly: true, // Prevent manual input
                  decoration: InputDecoration(
                    labelText: "Renewal Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        
                            _renewalDateController.text =
                            ('${selectedDate.toIso8601String().split('T')[0]}');  
                      });
                    }
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String name = _nameController.text;
              String description = _descriptionController.text;
              String amount = _amountController.text;

              if (name.isNotEmpty &&
                  description.isNotEmpty &&
                  amount.isNotEmpty &&
                  selectedType != null) {
                      double _enteredValue = double.tryParse(_amountController.text) ?? -1.0 ;
                // Pass data back or use it as needed
                Map<String, dynamic> incomeData = {
                  "name": name,
                  "description": description,
                  "amount": _enteredValue,
                  "type": selectedType,
                 "renewalDate": _renewalDateController.text,
                };

                Navigator.of(context).pop(incomeData);
              } else {
                // Show error message if fields are incomplete
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please complete all fields.")),
                );
              }
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}

}
