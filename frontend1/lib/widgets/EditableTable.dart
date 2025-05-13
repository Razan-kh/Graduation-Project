import 'package:flutter/material.dart';
class EditableTableSection extends StatefulWidget {
  const EditableTableSection({super.key});

  @override
  _EditableTableSectionState createState() => _EditableTableSectionState();
}

class _EditableTableSectionState extends State<EditableTableSection> {
  List<List<String>> data = [
    ['IELTS', 'November 4, 2022', '7.0'],
    ['TOEFL', 'December 1, 2022', '110'],
    ['GRE', 'July 5, 2022', '300'],
  ];

  List<String> columns = ['Test Name', 'Test Date', 'Result'];

  // Add a new row.
  void addRow() {
    setState(() {
      data.add(List.filled(columns.length, ''));
    });
  }

  // Update a cell's value.
  void updateCell(int row, int column, String value) {
    setState(() {
      data[row][column] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Standardized Testing',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns
                .map((column) => DataColumn(label: Text(column)))
                .toList(),
            rows: data.asMap().entries.map((entry) {
              final rowIndex = entry.key;
              final row = entry.value;

              return DataRow(
                cells: List<DataCell>.generate(row.length, (columnIndex) {
                  return DataCell(
                    TextFormField(
                      initialValue: row[columnIndex],
                      onFieldSubmitted: (value) =>
                          updateCell(rowIndex, columnIndex, value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: addRow,
          child: Text('Add Row'),
        ),
      ],
    );
  }
}

