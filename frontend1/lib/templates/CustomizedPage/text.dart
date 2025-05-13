import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/color.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';
import 'package:provider/provider.dart';

class TextPage extends StatefulWidget {
  //const TextPage({Key? key}) : super(key: key);
  
  final String text;
    final String pageId;
  final int index;
  final int fontColor;
 final  double fontSize;

  const TextPage({super.key, required this.text,required this.index,required this.pageId,required this.fontColor,required this.fontSize,});

  @override
  State<TextPage> createState() => TextPageState();
}

class TextPageState extends State<TextPage> {
  final TextEditingController _textController = TextEditingController();
     Color fontColor=Colors.black;
   double fontSize=24.0;
     final FocusNode _focusNode = FocusNode(); // Create a FocusNode
   
@override
void initState()
{
super.initState();
_textController.text=widget.text;
fontColor=Color(widget.fontColor);
fontSize=widget.fontSize;

print("fontcolor  is ${fontColor.runtimeType}");

  _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // This will be triggered when the TextField loses focus
        updateTextContent();
      }
    });
  
}
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final backgroundColor = context.watch<BackgroundColorNotifier>().backgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
    //  appBar: AppBar(title: const Text("To-Do List")),
      body: Padding(
        
        
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          
          controller: _textController,
           focusNode: _focusNode, 
         decoration: InputDecoration(
          
            hintText: "What do you think? ..",
            hintStyle: const TextStyle(color: Colors.grey),
               border: InputBorder.none,
           // border: const OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16),
          maxLines: null, // Allows the text area to expand vertically
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }

  void updateTextContent() {
  
      dynamic newContent = {
    'text':_textController.text,
    'fontSize' :fontSize,
    'fontColor':fontColor.value.toDouble(),
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }
}
