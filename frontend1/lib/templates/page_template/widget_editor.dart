import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'api_services.dart';

class WidgetEditor extends StatefulWidget {
  final String token;
  final String pageId;
  final String widgetId;
  final Map<String, dynamic> initialWidgetData;

  const WidgetEditor({super.key, 
    required this.token,
    required this.pageId,
    required this.widgetId,
    required this.initialWidgetData,
  });

  @override
  _WidgetEditorState createState() => _WidgetEditorState();
}

class _WidgetEditorState extends State<WidgetEditor> {
  late ApiService apiService;
  late Map<String, dynamic> widgetData;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'http://localhost:3000/api'); // Replace with backend URL
    widgetData = widget.initialWidgetData;
  }

  Future<void> _saveChanges() async {
    try {
      await apiService.updateWidgetStyle(
        widget.pageId,
        widget.widgetId,
        widgetData['styles'],
        widget.token,
      );
      Navigator.pop(context); // Go back after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color currentColor = Color(widgetData['styles']['color'] ?? 0xFF000000);
        return AlertDialog(
          title: Text('Pick a Color'),
          content: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              setState(() {
                widgetData['styles']['color'] = color.value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Widget'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widgetData['content']['text']),
              onChanged: (value) => widgetData['content']['text'] = value,
              decoration: InputDecoration(labelText: 'Edit Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickColor,
              child: Text('Pick Color'),
            ),
          ],
        ),
      ),
    );
  }
}
