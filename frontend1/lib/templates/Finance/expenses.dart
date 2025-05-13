import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Finance/classes/category.dart';
import 'package:frontend1/templates/Finance/classes/expense.dart';
import 'package:frontend1/templates/Finance/main0.dart';
import 'package:frontend1/templates/sideBar.dart';
  import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class expenses extends StatefulWidget {
 Category category ;
 final String token;
 final String financeId;
 expenses({required this.category,required this.token,required this.financeId});

 @override
 expensesState createState()=> expensesState();
}
class expensesState extends State<expenses> {
 late Category category;
 bool isLoading=true;
 @override
 void initState()
 {
  super.initState();
  category=widget.category;
  isLoading=false;
 }
  @override
    Widget build (BuildContext context)
    {
          final isWeb = MediaQuery.of(context).size.width > 600; // Determine if it's web

   return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Scaffold(
appBar: !isWeb
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => mainFinance(
                        token: widget.token,
                        financeId: widget.financeId,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text("Expenses"),
            )
          : null, // No AppBar for web if using a custom sidebar
      body: isWeb
          ? Row(
              children: [
                // Web sidebar
              WebSidebar(),
                     SizedBox(width:100),
                // Main content
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            isWeb? SizedBox(height:50):SizedBox(height:0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (context) => CategoryPopup(),
                                  );

                                  if (result != null && result is Map) {
                                    print("Expense Name: ${result['name']}");
                                    print("Expense Notes: ${result['notes']}");
                                    print("Expense Amount: ${result['amount']}");
                                    if (category?.id != null && category.id!.isNotEmpty) {
                                      print(category.id);
                                      addExpenseToCategory(category.id!, result['amount'], result['notes'], category.name, result['name']);
                                    }
                                  }
                                },
                                child: Text(
                                  "Add Expense",
                                  style: TextStyle(color: Colors.blue,fontSize: isWeb?30:18),
                                ),
                              ),
                            ),
                            Expanded(
                              child: category.expenses == null || category.expenses!.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No expenses added yet.",
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    )
                                  : ListView.builder(
  itemCount: category.expenses!.length,
  itemBuilder: (context, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add padding between each item
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),  // Rounded corners for a cleaner look
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4), // Shadow effect
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // More space within the ListTile
          leading: Icon(Icons.arrow_downward, color: Colors.red), // Icon on the left
          title: Text(
            category.expenses![index].name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bolder title for better readability
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              category.expenses?[index].notes!.isNotEmpty == true
                  ? Text(
                      category.expenses![index].notes!.toString(),
                      style: TextStyle(color: Colors.grey[700]),
                    )
                  : Text("No notes available", style: TextStyle(color: Colors.grey)),
              Text(
                category.expenses![index].date.toString(),
                style: TextStyle(color: Colors.grey[500], fontSize: 12), // Smaller date text
              ),
            ],
          ),
          trailing: Container(
            width: 100, // Set a specific width to keep trailing element aligned
            child: Text(
              category.expenses![index].amount.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Use color to highlight the amount
              ),
              textAlign: TextAlign.end, // Align the amount to the right
            ),
          ),
        ),
      ),
    );
  },
)

                            ),
                          ],
                        ),
                ),
                        SizedBox(width:100),
              ],
      
            )
          : Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => CategoryPopup(),
                      );

                      if (result != null && result is Map) {
                        print("Expense Name: ${result['name']}");
                        print("Expense Notes: ${result['notes']}");
                        print("Expense Amount: ${result['amount']}");
                        if (category?.id != null && category.id!.isNotEmpty) {
                          print(category.id);
                          addExpenseToCategory(category.id!, result['amount'], result['notes'], category.name, result['name']);
                        }
                      }
                    },
                    child: Text(
                      "Add Expense",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Expanded(
                  child: category.expenses == null || category.expenses!.isEmpty
                      ? Center(
                          child: Text(
                            "No expenses added yet.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: category.expenses!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(category.expenses![index].name),
                              leading: Icon(Icons.arrow_downward, color: Colors.red),
                              trailing: Text(category.expenses![index].amount.toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  category.expenses?[index].notes!.isNotEmpty == true
                                      ? Text(category.expenses![index].notes!.toString())
                                      : Text("No notes available"),
                                  Text(
                                    category.expenses![index].date.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      )
    );
  }

    
Future<void> addExpenseToCategory(String categoryId, double amount, String notes,String categoryName,String name) async {
  final url = Uri.parse('http://$localhost/api/category/$categoryId/expense');  // Use the correct base URL for your server

  try {
    // Prepare the expense data
    final expenseData = {
      'amount': amount,
      'category':categoryName,
      'name':name
,      'notes': notes,
    };

    // Send POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(expenseData),  // Encode the data as JSON
    );

    // Check for a successful response
    if (response.statusCode == 200) {
      // Parse the response if necessary (optional, if you need to display category data)
     final Map<String, dynamic> data  = json.decode(response.body);
      print('Category updated successfully: ${data}');
 Category decodedData =Category.fromJson(data);
     print('Category updated successfully: ${decodedData}');
      setState(() {
       category=decodedData;
       
      });
    } else {
      // Handle errors, e.g. category not found
      print('Error: ${response.statusCode}');
      final errorData = json.decode(response.body);
      print('Error message: ${errorData['message']}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}

  }


 class CategoryPopup extends StatefulWidget {
  @override
  _CategoryPopupState createState() => _CategoryPopupState();
}

class _CategoryPopupState extends State<CategoryPopup> {
     final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

  String? _selectedEmoji;
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Add Expense"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Expense Name",
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Expense Description",
              ),
            ),
            SizedBox(height: 16),
             TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Expense Amount",
              ),
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
  double _enteredValue = double.tryParse(_amountController.text) ?? -1.0 ;
            if (name.isNotEmpty && description.isNotEmpty && _enteredValue != -1) {
              // Pass data back or use it as needed
              Navigator.of(context).pop({
                "name": name,
                "notes": description,
                "amount": _enteredValue,
              });
            } else {
              // Show error message if fields are incomplete
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please complete all fields correctly.")),
              );
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }


}