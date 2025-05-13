import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';

class ResizableTable extends StatefulWidget {
  List<List<String>> cellData = [];
  List<Map<String, dynamic>> columnMetadata = []; // Tracks header name and column type
  Map<String, int> rowColors = {}; // Stores custom row colors
  int? headerColor;
  String pageId;
int index;
  ResizableTable({super.key, required this.cellData,required this.columnMetadata,required this.rowColors,required this.headerColor,required this.index,required this.pageId});


  @override
  _ResizableTableState createState() => _ResizableTableState();
}

class _ResizableTableState extends State<ResizableTable> {
   List<List<String>> cellData=[];
  List<Map<String, dynamic>> columnMetadata=[];
    Map<int, Color> rowColors ={};
  Color? headerColor;

int rowCount=1;
int columnCount =1;

  @override
  void initState() {
    super.initState();
     cellData = widget.cellData;
 columnMetadata = widget.columnMetadata; // Tracks header name and column type

  rowColors = widget.rowColors.map((key, value) {
    return MapEntry(int.parse(key), Color(value));  // Convert int to Color
  });
  
  // Convert headerColor from int to Color
  headerColor = widget.headerColor != null ?Color( widget.headerColor!) : null;

print("header color is ${headerColor.runtimeType}");
 rowCount = cellData.length;
 columnCount = cellData.isNotEmpty ? cellData[0].length : 0;

    _initializeTable();
  }

  void _initializeTable() {
    // Initialize cell data and column metadata
  // cellData = List.generate(rowCount, (_) => List.generate(columnCount, (_) => ''));
   // columnMetadata = List.generate(columnCount, (index) => {'header': 'Column $index', 'type': 'text'});
  }

  void _deleteSpecificColumn(int columnIndex) {
    print('Deleting column index: $columnIndex');
    print('Initial cellData: $cellData');

    if (columnCount > 1 && columnIndex >= 0 && columnIndex < columnCount) {
      setState(() {
        // Update cellData by removing the specific column from each row
        for (var row in cellData) {
          if (columnIndex < row.length) {
            row.removeAt(columnIndex);
          }
        }
        columnMetadata.removeAt(columnIndex);
        columnCount--;
        print('Updated cellData: $cellData');
        print('Updated columnCount: $columnCount');
      });
    }
       Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

  void _deleteSpecificRow(int rowIndex) {
    setState(() {
      if (rowIndex >= 0 && rowIndex < rowCount) {
        cellData.removeAt(rowIndex);
      }
    });
    rowCount--;

           Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

  void _addColumn(String columnType) {
    setState(() {
      columnCount++;
      columnMetadata.add({'header': 'Column $columnCount', 'type': columnType});
      for (var row in cellData) {
        row.add('');
      }
    });
           Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

  void _showAddColumnDialog() {
    String selectedType = 'text'; // Default column type
    List<String> options = []; // Store options for the "options" column
    TextEditingController optionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Column'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Select column type:'),
                  DropdownButton<String>(
                    value: selectedType,
                    items: [
                      DropdownMenuItem(value: 'text', child: const Text('Text')),
                      DropdownMenuItem(value: 'date', child: const Text('Date Picker')),
                      DropdownMenuItem(value: 'options', child: const Text('Dropdown Options')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        if (selectedType != 'options') {
                          options.clear(); // Clear options if type changes
                        }
                      });
                    },
                  ),
                  if (selectedType == 'options')
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Enter options:'),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: optionController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter option',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (optionController.text.trim().isNotEmpty) {
                                  setState(() {
                                    options.add(optionController.text.trim());
                                    optionController.clear();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (options.isNotEmpty)
                          Wrap(
                            spacing: 5.0,
                            children: options
                                .map((option) => Chip(
                                      label: Text(option),
                                      onDeleted: () {
                                        setState(() {
                                          options.remove(option);
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedType == 'options' && options.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please add at least one option.')),
                      );
                      return;
                    }
                    _addColumnWithTypeAndOptions(selectedType, options);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addColumnWithTypeAndOptions(String columnType, List<String> options) {
    setState(() {
      columnCount++;
      columnMetadata.add({
        'header': 'Column $columnCount',
        'type': columnType,
        'options': options,
      });
      for (var row in cellData) {
        row.add('');
      }
    });
           Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

  Widget _buildCell(int rowIndex, int colIndex) {
    Color rowColor = rowColors[rowIndex] ?? Colors.white; // Default to white if no color is set
    return Container(
      color: rowColor, // Set the background color for the entire cell
      child: Center( // Center the cell content
        child: _buildCellContent(rowIndex, colIndex),
      ),
    );
  }

  // Helper method for cell content
  Widget _buildCellContent(int rowIndex, int colIndex) {
    String columnType = columnMetadata[colIndex]['type'];
    if (columnType == 'text') {
      return TextFormField(
        initialValue: cellData[rowIndex][colIndex],
        onChanged: (value) {
          setState(() {
            cellData[rowIndex][colIndex] = value;
            Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
          });
        },
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      );
    } else if (columnType == 'date') {
      return InkWell(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          setState(() {
            cellData[rowIndex][colIndex] = selectedDate!.toIso8601String().split('T').first;
          });
                },
        child: Text(
          cellData[rowIndex][colIndex].isEmpty ? DateTime.now().toIso8601String().split('T').first.toString() : cellData[rowIndex][colIndex],
          textAlign: TextAlign.center,
        ),
      );
    } else if (columnType == 'options') {
      List<String> options = columnMetadata[colIndex]['options'];
      return DropdownButton<String>(
        value: cellData[rowIndex][colIndex].isEmpty ? null : cellData[rowIndex][colIndex],
        items: options
            .map((option) => DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: (value) {
          setState(() {
            cellData[rowIndex][colIndex] = value!;
            Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
          });
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          key: ValueKey('$rowCount-$columnCount-${cellData.hashCode}-${rowColors.hashCode}'),
          builder: (context, constraints) {
            double cellWidth = constraints.maxWidth / columnCount;
            double cellHeight = constraints.maxHeight / (rowCount + 1); // Include header row

            return Table(
              border: TableBorder.all(color: Colors.black),
              children: [
                // Header row
                TableRow(
                  children: List.generate(
                    columnCount,
                    (colIndex) => Container(
                      height: cellHeight,
                      alignment: Alignment.center,
                      color: headerColor ?? Colors.grey[300],
                      child: TextFormField(
                        initialValue: columnMetadata[colIndex]['header'],
                        onChanged: (value) {
                          setState(() {
                            columnMetadata[colIndex]['header'] = value;
                          });
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                // Data rows
                ...List.generate(
                  rowCount,
                  (rowIndex) => TableRow(
                    key: ValueKey('$rowIndex-${rowColors[rowIndex]?.hashCode}'),
                    children: List.generate(
                      columnCount,
                      (colIndex) => Container(
                        height: cellHeight,
                        alignment: Alignment.center,
                        color: rowColors[rowIndex] ?? Colors.white, // Use dynamic row color
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCell(rowIndex, colIndex),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Positioned(
          top: -15,
          right: -20,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'Add Row') {
                setState(() {
                  rowCount++;
                  cellData.add(List.generate(columnCount, (_) => ''));
                });
              } else if (value == 'Add Column') {
                _showAddColumnDialog();
              } else if (value == 'Delete Specific Row') {
                _showDeleteRowDialog();
              } else if (value == 'Delete Specific Column') {
                _showDeleteColumnDialog();
              }
              else if (value == 'Change Header Color') {
                _showChangeHeaderColorDialog();
              }
              else if (value == 'Change Row Color') {
                _showChangeRowColorDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Add Row', child: Text('Add Row')),
              const PopupMenuItem(value: 'Add Column', child: Text('Add Column')),
              const PopupMenuItem(value: 'Delete Specific Row', child: Text('Delete Specific Row')),
              const PopupMenuItem(value: 'Delete Specific Column', child: Text('Delete Specific Column')),
                 const PopupMenuItem(value: 'Change Header Color', child: Text('Change Header Color')),
              const PopupMenuItem(value: 'Change Row Color', child: Text('Change Row Color')),
            ],
          ),
        ),
      ],
    );
  }


void _showDeleteRowDialog() {
  showDialog(
    context: context,
    builder: (context) {
      int selectedRowIndex = 0; // Default selection

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Delete Specific Row'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select the row to delete:'),
                DropdownButton<int>(
                  value: selectedRowIndex,
                  items: List.generate(
                    rowCount,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text('Row ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the selected row index
                    setState(() {
                      selectedRowIndex = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Delete the selected row
                  _deleteSpecificRow(selectedRowIndex);
                   setState(() {
                    print(cellData);
                  });
                  Navigator.pop(context); // Close dialog
                 
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    },
  );
}
void _showDeleteColumnDialog() {
  print(cellData);
  showDialog(
    context: context,
    builder: (context) {
      int selectedColumnIndex = 0; // Default selection

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Delete Specific Column'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select the column to delete:'),
                DropdownButton<int>(
                  value: selectedColumnIndex,
                  items: List.generate(
                    columnCount,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text('Column ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the selected column index
                    setState(() {
                      selectedColumnIndex = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Call delete column method with the selected index
             _deleteSpecificColumn(selectedColumnIndex);
                  Navigator.pop(context); // Close dialog
                       
                        
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    },
  );
}
void _showChangeRowColorDialog() {
  showDialog(
    context: context,
    builder: (context) {
      int selectedRowIndex = 0; // Default to the first row

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Change Row Color'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select the row to change color:'),
                DropdownButton<int>(
                  value: selectedRowIndex,
                  items: List.generate(
                    rowCount,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text('Row ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedRowIndex = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Color initialColor = rowColors[selectedRowIndex] ?? Colors.white;
                  Color pickedColor = initialColor;

                  // Open color picker dialog
                  Color? newColor = await showDialog<Color>(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Pick a Color'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ColorPicker(
                                    pickerColor: initialColor,
                                    onColorChanged: (color) {
                                      pickedColor = color;
                                    },
                                    showLabel: true,
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Selected Color: $pickedColor',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context), // Cancel action
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, pickedColor), // Confirm action
                                child: const Text('Select'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  if (newColor != null) {
                    _changeColor(newColor,selectedRowIndex);
                    setState(() {
                      rowColors[selectedRowIndex] = newColor; // Update color in rowColors
                    });
                  }

                  Navigator.pop(context); // Close the row selection dialog
                },
                child: const Text('Change Color'),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _changeColor(Color newColor,selectedRowIndex) {
     setState(() {
                      rowColors[selectedRowIndex] = newColor; // Update color in rowColors
                    });
                           Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor,
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }
void _showChangeHeaderColorDialog() {
  showDialog(
    context: context,
    builder: (context) {
      // Initial color for the header (you can replace it with your current header color)
      Color initialHeaderColor = headerColor ?? Colors.blue;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Change Table Header Color'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: initialHeaderColor,
                    onColorChanged: (color) {
                      setState(() {
                        _changeHeaderColor(color);
                        initialHeaderColor = color; // Update the selected color dynamically
                      });
                    },
                    showLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selected Color: ${initialHeaderColor.toString()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, initialHeaderColor); // Confirm action with selected color
                },
                child: const Text('Select'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _changeHeaderColor(Color newHeaderColor) {
           Map<String,dynamic> newContent = {
   'rows': cellData,
            'columns': columnMetadata,
             'rowColors': rowColors,
            'headerColor': headerColor!.value.toDouble(),
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
    setState(() {
      headerColor=newHeaderColor;
    });
  }
  

}
