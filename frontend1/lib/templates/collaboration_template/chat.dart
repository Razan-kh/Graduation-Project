// // import 'package:flutter/material.dart';
// // import 'package:frontend1/config.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;

// // class ChatScreen extends StatefulWidget {
// //     final String templateId;

// //   const ChatScreen({Key? key, required this.templateId}) : super(key: key);
// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   List<Map<String, dynamic>> messages = [];
// //   IO.Socket? socket;
// //   final TextEditingController _controller = TextEditingController();
// //   final String currentUser = 'User'; // Replace with the actual current user's name
// // @override
// // void dispose() {
// //   // Cancel any async operations, like streams or timers

// //   super.dispose();
// // }
// //   @override
// //   void initState() {
// //     super.initState();
// //     _connectSocket();
  
// //     _fetchMessages();
// //   }

// //   void _connectSocket() {
// //     socket = IO.io('http://$localhost', <String, dynamic>{
// //       'transports': ['websocket'],
// //       'autoConnect': false,
// //     });
// //     socket!.connect();

// //     socket!.on('receiveMessage', (data) {
// //       setState(() {
// //         messages.add({
// //           'sender': data['sender'],
// //           'content': data['content'],
// //         });
// //       });
// //       print(messages);
// //     });
// //   }

// //   Future<void> _fetchMessages() async {
   
// //     final response = await http.get(Uri.parse('http://$localhost/api/projects/673603d1178704f4276cfe28/messages'));
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         messages = List<Map<String, dynamic>>.from(json.decode(response.body));
// //         print("messages are : ");
// //         print( messages);
// //       });
// //     }
// //   }

// // void _sendMessage() {
// //   // Assuming you have a variable `templateId` which holds the template ID
// //     print(_controller.text);
// //   final message = {
// //     'sender': currentUser,  // Current user sending the message
// //     'content': _controller.text,  // Content of the message
// //     'projectId': widget.templateId,  // The project ID associated with the message
// //   // The template ID you want to include with the message
// //   };
// //     setState(() {
// //     messages.add(message);
// //   });

// //   // Emit the message with projectId and templateId included
// //   final response=socket!.emit('sendMessage', message);

// //   // Clear the message input field after sending the message
// //   _controller.clear();
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Chat')),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final isSender = messages[index]['sender'] == currentUser;
// //                 return Align(
// //                   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
// //                   child: Container(
// //                     margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //                     padding: EdgeInsets.all(10),
// //                     decoration: BoxDecoration(
// //                       color: isSender ? Colors.blue[300] : Colors.grey[300],
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           messages[index]['sender'],
// //                           style: TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                         SizedBox(height: 5),
// //                         Text(messages[index]['content']),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration: InputDecoration(labelText: 'Type a message'),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
                
// //                   onPressed: _sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:jwt_decoder/jwt_decoder.dart';

// class ChatScreen extends StatefulWidget {
//   final String templateId;

//   const ChatScreen({Key? key, required this.templateId}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Map<String, dynamic>> messages = [];
//   IO.Socket? socket;
//   final TextEditingController _controller = TextEditingController();
//    String currentUser = 'User'; // Replace with actual current user
//     String? token;
//      String email="";

//   @override
//   void initState() {
//     super.initState();
//     _connectSocket();
//     _fetchMessages();
//        _retrieveUserInfo();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     socket?.dispose();
//     super.dispose();
//   }

// Future<void> _retrieveUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('token');

//     if (token != null) {
//       Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
//       setState(() {
//        email = decodedToken['email'];
//         currentUser=email.split('@')[0];
//       });
//       print("user is $currentUser");
//     }
//   }
//   void _connectSocket() {
//     socket = IO.io('http://$localhost', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     socket!.connect();

//     socket!.on('receiveMessage', (data) {
//       setState(() {
//         messages.add({
//           'sender': data['sender'],
//           'content': data['content'],
//         });
//       });
//     });
//   }

//   Future<void> _fetchMessages() async {
//     // Replace project ID with the appropriate ID if needed
//     final response = await http.get(Uri.parse('http://$localhost/api/projects/${widget.templateId}/messages'));
//     if (response.statusCode == 200) {
//       setState(() {
//         messages = List<Map<String, dynamic>>.from(json.decode(response.body));
//       });
//     }
//   }

//   void _sendMessage() {
//     final message = {
//       'sender': currentUser,
//       'content': _controller.text,
//       'projectId': widget.templateId,
//     };
// /*
//     setState(() {
//       messages.add(message);
//     });
// */
//     socket!.emit('sendMessage', message);
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkBackground = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Chat',
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final isSender = messages[index]['sender'] == currentUser;
//                 return Align(
//                   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(12),
//                     constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//                     decoration: BoxDecoration(
//                       color: isSender ? Colors.blue[100] : Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment:
//                           isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           messages[index]['sender'],
//                           style: GoogleFonts.montserrat(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           messages[index]['content'],
//                           style: GoogleFonts.montserrat(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: TextField(
//                       controller: _controller,
//                       style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         hintStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: _sendMessage,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[800],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(Icons.send, color: Colors.white, size: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatScreen extends StatefulWidget {
//   final String templateId;

//   const ChatScreen({Key? key, required this.templateId}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Map<String, dynamic>> messages = [];
//   IO.Socket? socket;
//   final TextEditingController _controller = TextEditingController();
//   final String currentUser = 'User'; // Replace with actual current user

//   @override
//   void initState() {
//     super.initState();
//     _connectSocket();
//     _fetchMessages();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     socket?.dispose();
//     super.dispose();
//   }

//   void _connectSocket() {
//     socket = IO.io('http://$localhost', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     socket!.connect();

//     socket!.on('receiveMessage', (data) {
//       setState(() {
//         messages.add({
//           'sender': data['sender'],
//           'content': data['content'],
//         });
//       });
//     });
//   }

//   Future<void> _fetchMessages() async {
//     // Replace project ID with the appropriate ID if needed
//     final response = await http.get(Uri.parse('http://$localhost/api/projects/${widget.templateId}/messages'));
//     if (response.statusCode == 200) {
//       setState(() {
//         messages = List<Map<String, dynamic>>.from(json.decode(response.body));
//       });
//     }
//   }

//   void _sendMessage() async {
//   if (_controller.text.trim().isEmpty) return;

//   final message = {
//     'sender': currentUser,
//     'content': _controller.text,
//   };

//   try {
//     // HTTP POST to save the message
//     final response = await http.post(
//       Uri.parse('http://$localhost/api/projects/${widget.templateId}/messages'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(message),
//     );

//     if (response.statusCode == 201) {
//       final newMessage = json.decode(response.body)['newMessage'];

//       // Update the local UI
//       setState(() {
//         messages.add({
//           'sender': newMessage['sender'],
//           'content': newMessage['content'],
//         });
//       });

//       // Emit the message via socket for real-time updates
//       socket!.emit('sendMessage', newMessage);
//     } else {
//       print('Failed to send message: ${response.body}');
//     }
//   } catch (error) {
//     print('Error sending message: $error');
//   }

//   _controller.clear();
// }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkBackground = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Chat',
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final isSender = messages[index]['sender'] == currentUser;
//                 return Align(
//                   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(12),
//                     constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//                     decoration: BoxDecoration(
//                       color: isSender ? Colors.blue[100] : Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment:
//                           isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           messages[index]['sender'],
//                           style: GoogleFonts.montserrat(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           messages[index]['content'],
//                           style: GoogleFonts.montserrat(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: TextField(
//                       controller: _controller,
//                       style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         hintStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: _sendMessage,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[800],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(Icons.send, color: Colors.white, size: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:jwt_decoder/jwt_decoder.dart'; // Add this package to your pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String templateId;

  const ChatScreen({super.key, required this.templateId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  IO.Socket? socket;
  final TextEditingController _controller = TextEditingController();
  String? email; // User's email
  String? userId; // User's ID
  String? token; // JWT token
   String currentUser = 'User'; // Replace with actual current user

  @override
  void initState() {
    super.initState();
    _retrieveUserInfo(); // Retrieve user info from token
    _connectSocket();
    _fetchMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    socket?.dispose();
    super.dispose();
  }

  Future<void> _retrieveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        email = decodedToken['email']; // Extract email
        userId = decodedToken['_id']; // Extract user ID
        if(email!=null)
            currentUser=email!.split('@')[0];
      });
    }
  }

  void _connectSocket() {
    socket = IO.io('http://$localhost', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();

    socket!.on('receiveMessage', (data) {
      setState(() {
        messages.add({
          'sender': data['sender'],
          'content': data['content'],
        });
      });
    });
  }

  Future<void> _fetchMessages() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/projects/${widget.templateId}/messages'),
      headers: {
        'Authorization': 'Bearer $token', // Pass token in headers
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || email == null) return;

    final message = {
      'sender': currentUser, // Use the user's email as sender
      'content': _controller.text,
            'projectId': widget.templateId,
    };

    try {
      // HTTP POST to save the message
      final response = await http.post(
        Uri.parse('http://$localhost/api/projects/${widget.templateId}/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Pass token in headers
        },
        body: json.encode(message),
      );

      if (response.statusCode == 201) {
        final newMessage = json.decode(response.body)['newMessage'];

        // Update the local UI
        setState(() {
          messages.add({
            'sender': newMessage['sender'],
            'content': newMessage['content'],
          });
        });

        // Emit the message via socket for real-time updates
        socket!.emit('sendMessage', newMessage);
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkBackground = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chat',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isSender = messages[index]['sender'] == currentUser;
                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[100] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          messages[index]['sender'],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          messages[index]['content'],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                child: TextField(
                      controller: _controller,
                      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
