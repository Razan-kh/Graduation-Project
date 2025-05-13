import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/templates/CustomizedPage/BulletPoints.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/color.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';
import 'package:frontend1/templates/CustomizedPage/calender.dart';
import 'package:frontend1/templates/CustomizedPage/icons.dart';
import 'package:frontend1/templates/CustomizedPage/image.dart';
import 'package:frontend1/templates/CustomizedPage/models/elemntModel.dart';
import 'package:frontend1/templates/CustomizedPage/models/pageModel.dart';
import 'package:frontend1/templates/CustomizedPage/table.dart';
import 'package:frontend1/templates/CustomizedPage/text.dart';
import 'package:frontend1/templates/CustomizedPage/toDoList.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CustomPage2 extends StatefulWidget {
  final PageModel page;

  const CustomPage2({super.key, required this.page});
  @override
  _CustomPageState createState() => _CustomPageState();
}
 
class _CustomPageState extends State<CustomPage2> with SingleTickerProviderStateMixin {
  late AnimationController _vibrationController;
  late Animation<double> _vibrationAnimation;
  bool isVibrating = false; // Track vibration state
  Color BackgroundColor=Colors.white;
Color toolBarColor=Colors.white;
  Color appBarColor=Colors.white;
  String _selectedEmoji = "😀"; // Default icon
  
  // List<ElementModel> _elements =[];
//  final <> _elementPositions = {}; // Map to store positions of elements

  bool isMenuVisible = false;
  bool showTrash = false;
Widget mapModelElementToWidget(ElementModel element,int index) {
  switch (element.type) {
    case 'table':
      return ResizableTable(cellData: element.content['rows'],columnMetadata: element.content['columns'],
      headerColor: element.content['headerColor'],rowColors: element.content['rowColors'],index: index,pageId:widget.page.id);
    case 'text':
  //  print(element.content['text']);
     return  TextPage(text:element.content['text'],fontColor:element.content['fontColor'],
fontSize:element.content['fontSize'],
index:index,pageId:widget.page.id);
    case 'image':
   print("inside image case ${element.content}");
   //print("hi");
    return ImageAttachmentWidget(index: index);
    case 'bullet':
    print("index is $index");
    print("tasks are ${element.content['tasks']}");
return Bulletpoints(tasks: element.content['tasks'],fontColor:  element.content['fontColor'],fontSize:  element.content['fontSize'], index: index,pageId:widget.page.id);
case 'todo':
return ToDoListPage(tasks: element.content['tasks'], index: index,pageId: widget.page.id);
case 'calendar':
return  MyCalendarPage(pageId:widget.page.id,index:index,events:(element.content['events'] as Map<String, String>)
    .map((key, value) => MapEntry(DateTime.parse(key), value))
);//events:  element.content['events']
 //index,events: element.content['events'])
//return Container(width: 500,height: 500,child: MyCalendarPage(pageId:widget.page.id,index:
 //index,events: element.content['events']));

    default:
      return Placeholder(); // A fallback widget for unknown element types
  }
}
List<Widget> _elements=[];
List <ElementModel> elementsModel=[];
  final TextEditingController _titleController = TextEditingController();
    Timer? _debounce; 
  @override
  void initState() {
    super.initState();
     _titleController.addListener(_onTextChanged);
     BackgroundColor=widget.page.BackgroundColor;
     appBarColor=widget.page.appBarColor;
     _selectedEmoji=widget.page.icon;
     _titleController.text= widget.page.title;
     toolBarColor=widget.page.toolBarColor;
     
      WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BackgroundColorNotifier>().changeColor(BackgroundColor);
  });

    //  print("widget.page is $widget.page");
   // _elements = widget.page.elements ;

 _elements = widget.page.elements
    .asMap() // Convert to a map of index -> element
    .map((index, element) {
      return MapEntry(index, mapModelElementToWidget(element, index)); // Pass index to the function
    })
    .values
    .toList();
elementsModel=widget.page.elements;

    // Initialize the AnimationController
    _vibrationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this, // Use the mixin to provide a TickerProvider
    );
      _vibrationAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _vibrationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _vibrationController.dispose(); // Clean up the animation controller
    super.dispose();
  }
  
  /*
    title: { type: String, required: true },
    BackgroundColor: {type:Number},
    appBarColor:{type:Number},
    icon:{type:String},
  */
  Future<void> updateCustomPage(String id, String field, dynamic value) async {
    final url = Uri.parse('http://$localhost/api/updateCustomPage/$id'); // Change to your server's URL

    final Map<String, dynamic> updatedData = {field: value};
    print("inside updateCustomPage , updated data is $updatedData");

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
       print(responseData);
        
      } else {
        throw Exception('Failed to update custom page');
      }
    } catch (error) {
      print('Error: $error');
     
    } 
  }


  // Add a new element and store its initial position
  void _addElement(ElementModel element) {
    setState(() {
   //   _elements.add(element);
     // _elementPositions[element] = Offset(100, 100); // Default position for new elements
    });
  }

  void _removeElement(int index) {
    setState(() {
      _elements.removeAt(index);
     elementsModel.removeAt(index);

    });
       deleteElementFromPage(index:index,pageId: widget.page.id);
  }

  Widget _toolbarButton(String label, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Function to update the icon when chosen


  void _onTextChanged() {
    // Debouncing logic to wait 1 second after the user stops typing
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(seconds: 1), () {
   //   _saveChangesToBackend();
   updateCustomPage(widget.page.id, "title", _titleController.text);
    });
  }
@override
Widget build(BuildContext context) {
  final pageProvider = Provider.of<PageProvider>(context);
   //   context.read<BackgroundColorNotifier>().changeColor(BackgroundColor);
  final screenSize = MediaQuery.of(context).size;
  final trashPosition = Offset(
    (screenSize.width - 40) / 2, // Center horizontally
    100, // Slightly above the bottom
  );

  return Scaffold(
    appBar: AppBar(
        backgroundColor: appBarColor,
      automaticallyImplyLeading: false, 
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
              Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardPage(),
                                            ),
                                      );
          },
        ),
        titleSpacing: 0,  // This removes extra spacing between the leading and the title
        // Editable title using TextField
        title:Row(
  children: [
   IconButton(
              icon:Text(
          _selectedEmoji,  // Display the selected emoji
          style: TextStyle(fontSize: 20),  // Adjust the size if necessary
        ),
              onPressed: () async {
               String? emoji = await chooseEmoji(context);
                setState(() {
                  _selectedEmoji = emoji!;
                });
                updateCustomPage(widget.page.id,"icon",_selectedEmoji);
                            }),
              
   
    Expanded(
      child: TextField(
        controller: _titleController,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    ),
  ],
)

        
          ),
        
      
    backgroundColor: BackgroundColor,
 body: Stack(
  children: [
    Stack(
        children: elementsModel.asMap().entries.map((entry) {
          int index = entry.key;
          final elementModel = entry.value;
          var element = _elements[index]; // Assuming _elements are initialized somewhere
          return Positioned(
            left: elementModel.position.dx ?? 100,
            top: elementModel.position.dy ?? 100,
            child: DraggableResizableWidget(
              position: elementModel.position,
              width: elementModel.size.width,
              height: elementModel.size.height,
              element: element,
              elementIndex: index,
              pageId:widget.page.id,
              pageProvider: pageProvider,
              onPositionChanged: (newPosition) {
                setState(() {
                  elementModel.position = newPosition;
                  updateElementPosition(widget.page.id,index,newPosition.dx,newPosition.dy);
                //  print("newPosition is $newPosition");
                });
              },
              onDragStart: () {
                setState(() {
                  showTrash = true; // Show the trash when dragging starts
                });
              },
              onDragEnd: (position) {
                setState(() {
                  _vibrationController.stop();
                  isVibrating = false;
                  showTrash = false; // Hide the trash when the drag ends
                });
                if ((position - trashPosition).distance < 100) {
                  _removeElement(index); // Remove the element if near trash
                }
              },
            ),
          );
        }).toList(), // Convert the map entries to a list of widgets
      ),
    
 

        // Top Menu (animated)
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: isMenuVisible ? 0 : -60, // Slide down/up
          left: 0,
          right: 0,
          child: Container(
            color: toolBarColor,
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.table_chart),
                    onPressed: () {
                      setState(() {
                       _createTable();
                      });
                    },
                  ),
                  
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                      _createCalender();
                      });
                    },
                  ),
                  
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      setState(() {
                   _createImageAttachment();
                    
                     print("elemnts are $_elements");
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () {
                      setState(() {
                       _createToDoList();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.circle_rounded),
                    onPressed: () {
                      setState(() {
                       _createBulletPoints();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.text_fields),
                    onPressed: () {
                      setState(() {
                     _createText();
                      });
                    },
                  ),
             
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      items: [
        const PopupMenuItem(value: 'Change BackGround Color', child: Text('Change BackGround Color')),
        const PopupMenuItem(value: 'Change AppBar Color', child: Text('Change AppBar Color')),
        const PopupMenuItem(value: 'Change ToolBar Color', child: Text('Change ToolBar Color')),
      ],
    ).then((value) {
      if (value == 'Change ToolBar Color') {
       _showChangeColorDialog(
      title: 'Change ToolBar Color',
      initialColor: toolBarColor ?? Colors.blue,
      onColorSelected: (color) {
        setState(() {
          toolBarColor = color; // Update the background color
        });
        updateCustomPage(widget.page.id, "toolBarColor",toolBarColor.value.toDouble());
      },
    );
      } else if (value == 'Change BackGround Color') {
       _showChangeColorDialog(
      title: 'Change Background Color',
      initialColor: BackgroundColor ?? Colors.blue,
      onColorSelected: (color) {
        setState(() {
           context.read<BackgroundColorNotifier>().changeColor(color);
          BackgroundColor = color; // Update the background color
        });
         updateCustomPage(widget.page.id, "BackgroundColor",BackgroundColor.value.toDouble() );
      },
    );
      } else if (value == 'Change AppBar Color') {
        _showChangeColorDialog(
      title: 'Change AppBar Color',
      initialColor: appBarColor ?? Colors.blue,
      onColorSelected: (color) {
        setState(() {
          appBarColor = color; // Update the background color
        });
         updateCustomPage(widget.page.id, "appBarColor",appBarColor.value.toDouble() );
      },
    );
      }
    });
  },
)

                ],
              ),
            ),
          ),
        ),

        // Trash Zone (with vibration animation)
        if (showTrash)
          AnimatedBuilder(
            animation: _vibrationController,
            builder: (context, child) {
              return Positioned(
                left: trashPosition.dx + _vibrationAnimation.value, // Apply vibration
                top: trashPosition.dy,
                child: Icon(
                  Icons.delete,
                  size: 40,
                  color: Colors.grey,
                ),
              );
            },
          ),

        // Floating Action Button to toggle menu, placed outside the SingleChildScrollView
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isMenuVisible = !isMenuVisible;
              });
            },
            child: Icon(isMenuVisible ? Icons.close : Icons.menu),
          ),
        ),
      ],
    ),



  );
}
void _createImageAttachment() async{

    final newElementModel=  await addElementToPage(type:'image',
size:Size(200, 100),
position:Offset(10, 20),
content:{
 'url': null, // URL is null
  }
);

if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add(ImageAttachmentWidget (index:_elements.length));
}
  }
  void _createCalender() async{
    final newElementModel=  await addElementToPage(type:'calendar',
size:Size(300, 300),
position:Offset(100, 100),
content: {
    'events': {
      '2024-12-25T00:00:00.000Z': 'Christmas Party',
    }, 
  }
);
  if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add(MyCalendarPage (index:_elements.length,pageId:widget.page.id,events:(newElementModel.content['events'] as Map<String, String>)
    .map((key, value) => MapEntry(DateTime.parse(key), value))
));//events:newElementModel.content['events']
}
  }


void _createText() async{
   // return  ResizableTable();
 final newElementModel=  await addElementToPage(type:'text',
size:Size(200, 100),
position:Offset(10, 20),
content:{
  'text': 'What do you think ?',
            'fontSize': 12.0,
            'fontColor': 4294951175,
  }
);
if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add( TextPage(text:newElementModel.content['text'],fontColor:newElementModel.content['fontColor'],
fontSize:newElementModel.content['fontSize'],
index: _elements.length,pageId:widget.page.id,
));
}
}

void _createBulletPoints() async{
   // return  ResizableTable();
 final newElementModel=  await addElementToPage(type:'bullet',
size:Size(200, 100),
position:Offset(10, 20),
content:{
  'tasks':['task1','task2'],
            'fontSize': 12.0,
            'fontColor': 4294951175,
  }
);

if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add(Bulletpoints(tasks: newElementModel.content['tasks'],fontColor: newElementModel.content['fontColor'],fontSize:newElementModel.content['fontSize'], index: _elements.length,pageId:widget.page.id));
}
  }
  void _createToDoList() async{
   // return  ResizableTable();
 final newElementModel=  await addElementToPage(type:'todo',
size:Size(200, 100),
position:Offset(100, 100),
content:{
  "tasks":[
   {"task": "", "checked": false}
   
  ]     
  }
);

if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add(ToDoListPage (tasks:newElementModel.content['tasks']  ,index:_elements.length,pageId: widget.page.id,));
}
  }

  void _createTable()async {
 final newElementModel=  await addElementToPage(type:'table',
size:Size(200, 100),
position:Offset(10, 20),
content:{
   "rows": [
    ['Cell 1', 'Cell 2'],
    ['Cell 3', 'Cell 4'],
  ],
  "columns": [
    {'header': 'Column 1', 'type': 'text'},
    {'header': 'Column 2', 'type': 'text'},
  ],
    "rowColors": {0: 4294966265, 1: 4293050560}, // Colors in integer format
    "headerColor": 4293893790 // Color in integer format
  }
);

if(newElementModel!=null){
  elementsModel.add(newElementModel);
_elements.add(ResizableTable(cellData: newElementModel.content['rows'],columnMetadata: newElementModel.content['columns'],
headerColor: newElementModel.content['headerColor'],rowColors: newElementModel.content['rowColors'],index:_elements.length,pageId:widget.page.id));
}

  }

Future<void> deleteElementFromPage({
  required String pageId,
  required int index,
}) async {
  final String apiUrl = 'http://$localhost/api/page/$pageId/element/$index'; // Replace with your API URL

  try {
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully deleted
      final data = json.decode(response.body);
      final updatedElements = data['updatedElements']; // Assuming the response contains updated elements
      print('Element deleted successfully! Updated elements: $updatedElements');
      /*
      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Element deleted successfully!')),
      );
      */
    } else {
      // Handle error
      print('Failed to delete element: ${response.body}');
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete element')),
      );
      */
    }
  } catch (e) {
    print('Error deleting element: $e');
    /*
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting element')),
    );
    */
  }
}
Future <ElementModel?> addElementToPage({
  required String type,
  required Offset position,
  required Size size,
  required Map<String, dynamic> content,
}) async {
  final String apiUrl = 'http://$localhost/api/pages/${widget.page.id}/elements';
  Map<String, dynamic> serializeContent(Map<String, dynamic> content) {
    return content.map((key, value) {
      if (value is Color) {
        return MapEntry(key, value.value); // Serialize Color as an integer
      } else if (value is Offset) {
        return MapEntry(key, {'x': value.dx, 'y': value.dy}); // Serialize Offset as a map
      } else if (value is Size) {
        return MapEntry(key, {'width': value.width, 'height': value.height}); // Serialize Size as a map
      } else if (value is Map<int, int>) { // Serialize Map<int, int> as a map with string keys
        return MapEntry(key, value.map((k, v) => MapEntry(k.toString(), v)));
      } else if (value is Map) {
        return MapEntry(key, serializeContent(value.cast<String, dynamic>())); // Serialize nested maps
      } else if (value is List) {
        return MapEntry(key, value.map((item) {
          if (item is Map) {
            return serializeContent(item.cast<String, dynamic>());
          }
          return item; // Primitive values are kept as is
        }).toList());
      } else {
        return MapEntry(key, value); // Keep other values as is
      }
    });
  }


final serializedContent = serializeContent(content);

  try {
    // Construct the body for the POST request
    final Map<String, dynamic> requestBody = {
      'type': type,
      'position': {'x':position.dx ,'y':position.dy},
      'size': {'width':size.width, 'height':size.height },
      'content': serializedContent
      //serializeContent(content),
    };
   
print(requestBody);
    // Make the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        
      },
      body: jsonEncode(requestBody),
    );

   
    if (response.statusCode == 201) {
      // Parse the response body
   final json = jsonDecode(response.body);
    print(json);
    final data=json['newElement'];
    return ElementModel.fromJson(data);
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      return null;
    }
  } catch (error) {
    print('Error creating element: $error');
    return null;
  }
}
 Timer? debounceTimer;
Future<void> updateElementPosition(String pageId, int elementIndex, double x, double y) {
    final completer = Completer<void>();
  if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: 500), () async {
  // Define the API endpoint URL
  final url = Uri.parse('http://$localhost/api/pages/$pageId/elements/$elementIndex/position');

  // Prepare the request body as a Map
  final Map<String, dynamic> requestBody = {
    'x': x,
    'y': y,
  };
 String? token = await getToken();
  // Make the PATCH request
  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Successfully updated the position
      print('Element position updated successfully');
    } else {
      // Failed to update the position
      print('Failed to update position. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
finally {
      // Complete the completer, ensuring the function resolves
      completer.complete();
    }
  });

  return completer.future;

//  return ;
}
void _showChangeColorDialog({
  required String title,
  required Color initialColor,
  required Function(Color) onColorSelected,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
           Color currentColor = initialColor;
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: initialColor,
                    onColorChanged: (color) {
                      setState(() {
                        currentColor = color;
                        initialColor = color; // Update the selected color dynamically
                      });
                    },
                    showLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selected Color: ${initialColor.toString()}',
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
                    onColorSelected(currentColor); // Apply color change dynamically
                  Navigator.pop(context, initialColor); // Confirm action with selected color
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


}

class DraggableResizableWidget extends StatefulWidget {
  final Widget element;
 final String pageId;
  final Offset  position;
  final Function(Offset) onPositionChanged;
  final VoidCallback onDragStart;
  final Function(Offset) onDragEnd;
  final double width;
  final double height;
  final int elementIndex; // Add index to identify the element
  final PageProvider pageProvider; // Pass the PageProvider to the widget

  const DraggableResizableWidget({
    super.key,
    required this.element,
    required this.onPositionChanged,
    required this.onDragStart,
    required this.onDragEnd,
    required this.width,
    required this.height,
        required this.position,
    required this.elementIndex, // Accept element index
    required this.pageProvider, // Pass PageProvider instance
    required this.pageId,
  });

  @override
  _DraggableResizableWidgetState createState() =>
      _DraggableResizableWidgetState();
}

class _DraggableResizableWidgetState extends State<DraggableResizableWidget> {
  Offset position=Offset(100,100);
    Timer? debounceTimer;
@override
void initstate()
{
  super.initState();
position = widget.position;
//print("inside draggableResizable , element is ${widget.element}, width is ${widget.width} height is ${widget.height} ");
}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        widget.onDragStart();
      },
      onPanUpdate: (details) {
        setState(() {
          position = Offset(
            (position.dx + details.delta.dx)
                .clamp(0, MediaQuery.of(context).size.width - widget.width),
            (position.dy + details.delta.dy)
                .clamp(0, MediaQuery.of(context).size.height - widget.height),
          );
        });

        widget.onPositionChanged(position);
      },
      onPanEnd: (_) {
        widget.onDragEnd(position);
      },
      child: ResizableWidget(
        width: widget.width,
        height: widget.height,
        position:widget.position,
        onResize: (newWidth, newHeight) {
          // Update the size of the element in PageProvider
          widget.pageProvider.updateElementSize(widget.elementIndex, newWidth, newHeight);
       updateElementSize(widget.pageId,widget.elementIndex,newWidth,newHeight);
        },
        child: widget.element,
      ),
    );
  }
  
Future<void> updateElementSize(String pageId, int elementIndex, double newWidth, double newHeight) {
    final completer = Completer<void>();
  if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: 500), () async {
  // API endpoint for updating element size
  final String apiUrl = 'http://$localhost/api/pages/$pageId/elements/$elementIndex/size';
    String? token = await getToken();
  // Headers for the request
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Replace with actual token if needed
  };

  // Request body
  final Map<String, dynamic> body = {
    'pageId': pageId,
    'elementIndex': elementIndex,
    'newWidth': newWidth,
    'newHeight': newHeight,
  };

  // Try sending the PATCH request to update the element size
  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    // Check for successful response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: ${data['message']}');
      print('Updated Page: ${data['updatedPage']}');
    } else {
      print('Failed to update size. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error updating size: $error');
  }
finally {
      // Complete the completer, ensuring the function resolves
      completer.complete();
    }
  });

  return completer.future;

//  return ;
}
}

class ResizableWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Offset position;
  final Function(double, double) onResize;

  const ResizableWidget({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    required this.onResize,
    required this.position,
  });

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
  //  print("inside resizable widget width is $width , height is $height position is ${widget.position}, element is ${widget.child}");
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
          SizedBox(
          width: widget.width,
          height: widget.height, // Limit height
          child: widget.child,
        ),
     
      // Resize handle at bottom-right corner
      Positioned(
        right: 0,
        bottom: 0,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              final maxWidth = screenSize.width - widget.position.dx;
              final maxHeight = screenSize.height - widget.position.dy;
     // Adjust width and height incrementally using delta values
         double scaleFactor = 0.9; 
                width = (width + details.delta.dx*scaleFactor).clamp(50, maxWidth);
                height = (height + details.delta.dy*scaleFactor).clamp(50, maxHeight);
            });

            // Notify parent of new size
            widget.onResize(width, height);
          },
            child: SizedBox(
              width: 20,
              height: 20,
            //  color: BackgroundColor,
              child: Icon(Icons.drag_handle, size: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
