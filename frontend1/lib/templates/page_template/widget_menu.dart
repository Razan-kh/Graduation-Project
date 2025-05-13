import 'package:flutter/material.dart';

class WidgetMenu extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddWidget;

  const WidgetMenu({super.key, required this.onAddWidget});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> widgetOptions = [
      {'type': 'text', 'content': {'text': 'New Text Widget'}, 'styles': {}},
      {'type': 'quote', 'content': {'text': 'Inspirational Quote'}, 'styles': {}},
      {'type': 'bulleted_list', 'content': {'items': ['Item 1']}, 'styles': {}},
      {'type': 'divider', 'content': {}, 'styles': {}}, // Divider doesn't need content
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Add Widget')),
      body: ListView.builder(
        itemCount: widgetOptions.length,
        itemBuilder: (context, index) {
          final widgetOption = widgetOptions[index];
          return ListTile(
            title: Text(widgetOption['type']),
            onTap: () {
              final widgetData = {
                ...widgetOption,
                'position': DateTime.now().millisecondsSinceEpoch,
              };
              onAddWidget(widgetData); // Pass to parent
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
