import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/icons.dart';
import 'package:frontend1/templates/Finance/classes/category.dart';
import 'package:frontend1/templates/Finance/classes/finance.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Finance/expenses.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';


class FinancePage extends StatefulWidget {
  
  final String financeId;
  
  final String token;
   Finance finance;
 FinancePage({required this.finance, required this.token,required this.financeId});


//FinancePage({required this.finance,required this.financeId});
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  late Finance _finance;
  //bool _isLoading = true;
 // bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _finance=widget.finance;
    // Fetch finance data by ID when the page is initialized
   // fetchFinanceById(widget.financeId);
  }
/*
  // Fetch Finance data by its ID
  Future<void> fetchFinanceById(String id) async {
    try {
      final response =
          await http.get(Uri.parse('http://$localhost/api/finances/$id'));

      if (response.statusCode == 200) {
        setState(() {
        

              final Map<String, dynamic> data = json.decode(response.body);
print("data is $data");
          _finance = Finance.fromJson(data);
          print(" ${_finance.subscriptions }  ${_finance.incomes}  ${_finance.net}  ${_finance.bills[0].name}  ${_finance.categories[0].id}");
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load finance with ID: $id');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
      return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      child: Padding(
      padding: const EdgeInsets.all(1.0),
    /*  appBar: AppBar(
        title: Text('Finance Details'),
      ),
      */
      child: SingleChildScrollView(
 child : //_isLoading ? CircularProgressIndicator():
   Column(
        children: [
        
          // Pie Chart
          Container(
            height: 250,
            padding: EdgeInsets.all(16),
            child: PieChartWidget(categories :_finance.categories),
          ),
          // ListTiles
          //  Align(
          //  alignment: Alignment.centerLeft,
          //  child:
          Align(
            alignment: Alignment.centerLeft,
            child: 
      TextButton(onPressed: ()async {
 final result = await showDialog(
    context: context,
    builder: (context) => CategoryPopup(),
  );

  if (result != null && result is Map) {
    print("Category Name: ${result['name']}");
    print("Category Icon: ${result['icon']}");
    print("Category Description: ${result['description']}");
    addCategory(result['name'],result['description'],result['icon'],);


  }
      }, child: Text("Add Category",style: TextStyle(color: Colors.blue),)),
   ),
  // ),
         ..._finance.categories.asMap().entries.map((entry) {
          int index = entry.key;
          final category = entry.value;
    
          //  child: ListView.builder(
             //  shrinkWrap: true; // Ensures ListView takes only as much height as needed
              //physics: NeverScrollableScrollPhysics(); // Prevents ListView from scrolling independently
            //  itemCount: _finance.categories.length, // Number of items in the list
             // itemBuilder: (context, index) {
              return Dismissible(
        key: Key(category.id.toString()), // Ensure each item has a unique key
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
        deleteCategory(category.id).then((_) {
    setState(() {
      String id=category.id;
      // Remove the reminder from your local list after successful deletion
      _finance.categories.removeWhere((category) =>id == category.id);
    });
  }).catchError((error) {
    print('Failed to delete category: $error');
  });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category dismissed')),
          );
        },
        child: ListTile(
                  leading: IconButton(
              icon:Text(
         _finance.categories[index].icon!= null ?_finance.categories[index].icon! :"home",  // Display the selected emoji
          style: TextStyle(fontSize: 20),  // Adjust the size if necessary
        ),
        onPressed: () {  },
                  ),
                  title: Text(_finance.categories[index].name),
                 // subtitle: Text('Details about item ${index + 1}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => expenses(category: _finance.categories[index],token:widget.token,financeId: widget.finance.id,)),
        ); 
                  },
        ),
                );
              }).toList(),
          
        ],
   ),
      ),
      )
    );
  }

  Future<void> addCategory(String name, String description,String _selectedIcon) async {
    try {
      final response = await http.post(
        Uri.parse("http://$localhost/api/finance/${widget.financeId}/category"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "description": description.isNotEmpty ? description : null,
          "icon": _selectedIcon,
        }),
      );

      if (response.statusCode == 201 || response.statusCode==200) {
          print("category Added successfully");
          final data=json.decode(response.body);
          print(data['category']);
          Category newCategory=Category.fromJson(data['category']);
          setState(() {
                      _finance.categories.add(newCategory);
          });

      } else {
        final error = json.decode(response.body);
       print("error creating category $error");
        
      }
    } catch (e) {
     print("failed to create category $e");
     
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
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

Future<void> deleteCategory(String categoryId) async {
  final String url = 'http://$localhost/api/category/$categoryId'; // Replace with your API URL

  try {
    // Send the DELETE request to the server
    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // If the category was deleted successfully, show a success message
     print("deleted successfully");
    } else {
      // If there was an error (e.g., category not found), show an error message
      final responseData = json.decode(response.body);
    
    }
  } catch (error) {
    // If there's a network or server error, show a general error message
  print(error);
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
  String? _selectedEmoji;
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Add Category"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Category Name",
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Category Description",
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Category Icon: "),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    String? emoji = await chooseEmoji(context);
                    if (emoji != null) {
                setState(() {
            
                      _selectedEmoji = emoji;
                            print(_selectedEmoji);
                });
                    }
                  },
                  child: CircleAvatar(
                    radius: 20,
                    child: Text(
                      _selectedEmoji ?? "+",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
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

            if (name.isNotEmpty && description.isNotEmpty && _selectedEmoji != null) {
              // Pass data back or use it as needed
              Navigator.of(context).pop({
                "name": name,
                "icon": _selectedEmoji,
                "description": description,
              });
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
  }
}




class PieChartWidget extends StatefulWidget {
  List<Category> categories;
    PieChartWidget({required this.categories});
    @override
    PieChartWidgetState createState()=> PieChartWidgetState();
}
    class PieChartWidgetState extends State<PieChartWidget> {

   final Random random = Random();
   Color getRandomColor() {
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
  @override
  Widget build(BuildContext context) {

   return SfCircularChart(
  legend: Legend(isVisible: true),
  series: <CircularSeries>[
    PieSeries<Category, String>(
      dataSource: widget.categories.where((category) => category.totalAmount > 0).toList(),
      xValueMapper: (Category data, _) => data.name,
      yValueMapper: (Category data, _) => data.totalAmount,
      pointColorMapper: (Category data, _) => getRandomColor(),
      dataLabelSettings: DataLabelSettings(isVisible: true),
    ),
  ],
);

  }
    }