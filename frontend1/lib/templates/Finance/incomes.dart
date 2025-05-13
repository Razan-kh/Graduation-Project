import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Finance/classes/finance.dart';
import 'package:frontend1/templates/Finance/classes/income.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomePage extends StatefulWidget {
  final Finance finance;
  IncomePage({required this.finance});
@override 
IncomePageState createState() =>IncomePageState();
}
class IncomePageState extends State<IncomePage> {
  late List <Income> incomes;
  
  @override
  void initState()
  {
    super.initState();
    incomes=widget.finance.incomes;

  }
  /*
  final List<Map<String, dynamic>> incomes = [
    {
      "name": "Freelance Work",
      "amount": 500,
      "date": "12/20/2024",
      "category": "Side Hustle",
      "notes": "Completed project XYZ"
    },
    {
      "name": "Salary",
      "amount": 2000,
      "date": "12/15/2024",
      "category": "Job",
      "notes": "Monthly payment"
    },
    {
      "name": "Gift",
      "amount": 100,
      "date": "12/05/2024",
      "category": "Personal",
      "notes": "Birthday gift from a friend"
    },
  ];
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             

            children:[  TextButton(onPressed: ()async {
 final result = await showDialog(
    context: context,
    builder: (context) => IncomePopup(),
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
addIncomeToFinance(widget.finance.id, incomeData);

  }
      }, child: Text("Add Income",style: TextStyle(color: Colors.blue),)),

            ...incomes.map((income) => IncomeCard(income: income , onDelete: (incomeId) {
            setState(() {
              // Remove the deleted income from the list
              incomes.removeWhere((income) => income.id == incomeId);
            });
          },
          )).toList(),
            ],
          ),
        ),
      ),
     
    );
  }



  // Function to add Income to Finance
  Future<void> addIncomeToFinance(String financeId, Map<String, dynamic> incomeData) async {
    try {
      final response = await http.post(
        Uri.parse('http://$localhost/api/$financeId/incomes'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(incomeData),
      );

      if (response.statusCode == 201) {
        final data= jsonDecode(response.body);
        print(data);
        Income i=Income.fromJson(data['income']);
        setState(() {
                  incomes.add(i);
        });
      } else {
        print('Failed to add income. Status code: ${response.statusCode}');

      }
    } catch (error) {
      print('Error adding income: $error');
     
    }
  }
}

class IncomeCard extends StatefulWidget {
  final Income income;
  final Function onDelete; 
  const IncomeCard({Key? key, required this.income,required this.onDelete}) : super(key: key);

  @override
  _IncomeCardState createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  bool _isExpanded = false; // Flag to track if the card is expanded or not

  @override
  Widget build(BuildContext context) {
     DateTime? renewalDate = (widget.income.date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(renewalDate!);

 return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Dismissible(
        key: Key(widget.income.toString()), // Ensure each item has a unique key
        direction: DismissDirection.endToStart, // Swipe direction (right-to-left)
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
                    return await _showDeleteConfirmationDialog(context);
                  },

        onDismissed: (direction) {
          // Handle dismissal logic (e.g., remove item from the list)
        deleteIncome(widget.income.id).then((_) {
    setState(() {
      String id=widget.income.id;
      // Remove the income from your local list after successful deletion
        widget.onDelete(widget.income.id); 
   
    });
  }).catchError((error) {
    print('Failed to delete category: $error');
  });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Income dismissed')),
          );
        },
        
        child:
    GestureDetector(
      onTap: () {
        // Toggle the state of the card on tap
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },

      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(bottom: 12.0),
        child: Container(
          width: double.infinity, // Full width
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
               Icon(Icons.arrow_upward,color: Colors.green,) ,
  Text(
              widget.income.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ],),
            
              SizedBox(height: 4),
              Text("Amount: \$${widget.income.amount}", style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
             
              // Show notes only if the card is expanded
              if (_isExpanded) 
                Text(
                  widget.income.notes?? "No notes available",
                  style: TextStyle(color: Colors.black),
                  
                ),
               if (_isExpanded)  Text("Renewal Date: ${formattedDate}", style: TextStyle(color: Colors.black)),
             if (_isExpanded)    SizedBox(height: 4),
                  if (_isExpanded)     Text("Type: ${widget.income.type}", style: TextStyle(color: Colors.black)),
             if (_isExpanded)    SizedBox(height: 4),
              if (_isExpanded)   Text("Category: ${widget.income.type}", style: TextStyle(color: Colors.black)),
             if (_isExpanded)    SizedBox(height: 8),
             
              
            ],
          ),
        ),
      ),
    )
      )
    );
  }

  
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Income'),
          content: Text('Are you sure you want to delete this Income?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ??
        false;
  }
Future<void> deleteIncome(String incomeId) async {
  final String url = 'http://$localhost/api/income/$incomeId'; // Replace with your API URL

  try {
    // Send the DELETE request to the server
    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // If the income was deleted successfully, show a success message
    print("income deleted successfully");
    } else {
      // If there was an error (e.g., income not found), show an error message
      final responseData = json.decode(response.body);
      
    }
  } catch (error) {
    // If there's a network or server error, show a general error message
    print(error);
  }
}
}


 class IncomePopup extends StatefulWidget {
  @override
 IncomePopupState createState() => IncomePopupState();
}

class IncomePopupState extends State<IncomePopup> {
     final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

  String? _selectedEmoji;
 Widget build(BuildContext context) {
  String? selectedType = "monthly"; // Default value for the dropdown
  bool showRenewalDateField = true; // Boolean to toggle the renewalDate field

  final TextEditingController _renewalDateController = TextEditingController();

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text("Add Income"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Income Name",
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
                items: [ "monthly", "weekly", "yearly", "one-time"]
          
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                    showRenewalDateField = selectedType != "one-time";
                  });
                },
                decoration: InputDecoration(
                  labelText: "Type",
                ),
              ),
              SizedBox(height: 16),
              if (showRenewalDateField)
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
                // Pass data back or use it as needed
                Map<String, dynamic> incomeData = {
                  "name": name,
                  "description": description,
                  "amount": amount,
                  "type": selectedType,
                  if (selectedType != "one-time") "renewalDate": _renewalDateController.text,
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
