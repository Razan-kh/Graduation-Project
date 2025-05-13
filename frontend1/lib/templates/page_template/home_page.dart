import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'api_services.dart';
import 'widget_menu.dart';
import 'widget_editor.dart';

class HomePage extends StatefulWidget {
  final String token;
  final String templateId;

  const HomePage({super.key, required this.token, required this.templateId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  List<Map<String, dynamic>> widgets = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'http://$localhost/api'); // Replace with backend URL
    _fetchPageData();
  }
Future<void> _fetchPageData() async {
  try {
    final data = await apiService.fetchPage(widget.templateId, widget.token);
    setState(() {
      widgets = List<Map<String, dynamic>>.from(data['widgets'])
          .where((widget) => widget['position'] != null) // Ensure position is not null
          .toList();

      widgets.sort((a, b) =>
          (a['position'] as int).compareTo(b['position'] as int)); // Sort by position
    });
  } catch (e) {
    print('Error fetching page data: $e');
  }
}



  void _navigateToWidgetEditor(String widgetId, Map<String, dynamic> widgetData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WidgetEditor(
          token: widget.token,
          pageId: widget.templateId,
          widgetId: widgetId,
          initialWidgetData: widgetData,
        ),
      ),
    ).then((_) => _fetchPageData());
  }

  Widget buildWidget(Map<String, dynamic> widgetData) {
  switch (widgetData['type']) {
    case 'text':
      return GestureDetector(
        onTap: () => _navigateToWidgetEditor(widgetData['_id'], widgetData),
        child: Text(
          widgetData['content']['text'] ?? '',
          style: TextStyle(
            fontSize: (widgetData['styles']?['fontSize'] ?? 14.0).toDouble(),
            color: Color(widgetData['styles']?['color'] ?? 0xFF000000),
          ),
        ),
      );
    case 'quote':
      return GestureDetector(
        onTap: () => _navigateToWidgetEditor(widgetData['_id'], widgetData),
        child: Text(
          widgetData['content']['text'] ?? '',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
            color: Color(widgetData['styles']?['color'] ?? 0xFF000000),
          ),
        ),
      );
    default:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Unsupported widget type: ${widgetData['type']}'),
      );
  }
}


  void _navigateToWidgetMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WidgetMenu(onAddWidget: _addNewWidget),
      ),
    );
  }

  Future<void> _addNewWidget(Map<String, dynamic> widgetData) async {
    try {
      final addedWidget = await apiService.addWidget(widget.templateId, widgetData, widget.token);
      setState(() {
        widgets.add(addedWidget);
        widgets.sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));
      });
    } catch (e) {
      print('Error adding widget: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToWidgetMenu,
          ),
        ],
      ),
      body: widgets.isEmpty
          ? Center(child: Text('No widgets found. Add some!'))
          : ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                return buildWidget(widgets[index]);
              },
            ),
    );
  }
}
