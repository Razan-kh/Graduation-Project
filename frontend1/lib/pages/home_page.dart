import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  bool showButtons = false;  // This controls visibility of the buttons
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController(text: 'New page');

  Timer? _debounce;  // Timer for debouncing

  @override
  void initState() {
    super.initState();
    // Add a listener to the _controller for autosave on content change
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _debounce?.cancel();  // Cancel debounce timer if any
    super.dispose();
  }

  void _onTextChanged() {
    // Debouncing logic to wait 1 second after the user stops typing
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(seconds: 1), () {
      _saveChangesToBackend();
    });
  }

  // Function to save changes to backend (autosave)
  Future<void> _saveChangesToBackend() async {
    final url = 'http://192.168.1.23:3000/api/pages/1';  // Replace with correct backend URL

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': _titleController.text,  // Send title and content to backend
          'content': _controller.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Changes saved successfully');
      } else {
        print('Failed to save changes');
      }
    } catch (error) {
      print('Error saving changes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        titleSpacing: 0,  // This removes extra spacing between the leading and the title
        // Editable title using TextField
        title: TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            border: InputBorder.none,  // No border for a clean look
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display buttons if showButtons is true
            if (showButtons)
              Row(
                children: [
                  TextButton(
                      onPressed: () {}, child: const Text('Add icon')),
                  TextButton(
                      onPressed: () {}, child: const Text('Add cover')),
                  TextButton(
                      onPressed: () {}, child: const Text('Add comment')),
                ],
              ),
            // Tapping the TextField will toggle the button visibility
            GestureDetector(
              onTap: () {
                setState(() {
                  showButtons = !showButtons;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 40),
                  decoration: InputDecoration(
                    hintText: 'New page',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ),

            const Spacer(),
            // Fix for RenderFlex overflow
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {}, 
                    child: const Text(
                      'Ask AI',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {}, 
                    child: const Text(
                      'Draft anything',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {}, 
                    child: const Text(
                      'Templates',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}