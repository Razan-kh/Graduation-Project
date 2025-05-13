// import 'package:flutter/material.dart';
// import 'api_service.dart';

// class WhiteboardPage extends StatefulWidget {
//   final String token;
//   final String templateId;

//   const WhiteboardPage({required this.token, required this.templateId, Key? key}) : super(key: key);

//   @override
//   State<WhiteboardPage> createState() => _WhiteboardPageState();
// }

// class _WhiteboardPageState extends State<WhiteboardPage> {
//   late ApiService apiService;
//   List<Offset?> points = [];

//   @override
//   void initState() {
//     super.initState();
//     apiService = ApiService(widget.token);
//     _loadWhiteboard();
//   }

//   Future<void> _loadWhiteboard() async {
//   try {
//     final whiteboardData = await apiService.getWhiteboardData(widget.templateId);
//     print("Fetched whiteboard data: $whiteboardData");

//     setState(() {
//       points = whiteboardData.map<Offset?>((point) {
//         if (point == null) return null;
//         if (point['x'] != null && point['y'] != null) {
//           // Explicitly cast 'x' and 'y' to double
//           return Offset((point['x'] as num).toDouble(), (point['y'] as num).toDouble());
//         }
//         return null; // Handle malformed data
//       }).toList();
//     });

//     print("Mapped points to Offset: $points");
//   } catch (e) {
//     print("Error loading whiteboard data: $e");
//   }
// }


//   Future<void> _saveWhiteboard() async {
//     try {
//       final dataToSave = points.map((e) => e != null ? {'x': e.dx, 'y': e.dy} : null).toList();
//       await apiService.saveWhiteboardData(widget.templateId, dataToSave);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Whiteboard saved!")));
//     } catch (e) {
//       print("Error saving whiteboard: $e");
//     }
//   }

//   void _clearWhiteboard() {
//     setState(() {
//       points.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Whiteboard"),
//         actions: [
//           IconButton(icon: Icon(Icons.save), onPressed: _saveWhiteboard),
//           IconButton(icon: Icon(Icons.clear), onPressed: _clearWhiteboard),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return GestureDetector(
//                   onPanUpdate: (details) {
//                     setState(() {
//                       points.add(details.localPosition);
//                     });
//                   },
//                   onPanEnd: (details) {
//                     points.add(null);
//                   },
//                   child: CustomPaint(
//                     painter: WhiteboardPainter(points),
//                     size: Size(constraints.maxWidth, constraints.maxHeight),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WhiteboardPainter extends CustomPainter {
//   final List<Offset?> points;

//   WhiteboardPainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 5.0;

//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i]!, points[i + 1]!, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class WhiteboardPage extends StatefulWidget {
  final String token;
  final String templateId;

  const WhiteboardPage({required this.token, required this.templateId, super.key});

  @override
  State<WhiteboardPage> createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  late ApiService apiService;
  List<Offset?> points = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService(widget.token);
    _loadWhiteboard();
  }

  Future<void> _loadWhiteboard() async {
    try {
      final whiteboardData = await apiService.getWhiteboardData(widget.templateId);
      setState(() {
        points = whiteboardData.map<Offset?>((point) {
          if (point == null) return null;
          if (point['x'] != null && point['y'] != null) {
            return Offset((point['x'] as num).toDouble(), (point['y'] as num).toDouble());
          }
          return null; 
        }).toList();
      });
    } catch (e) {
      print("Error loading whiteboard data: $e");
    }
  }

  Future<void> _saveWhiteboard() async {
    try {
      final dataToSave = points.map((e) => e != null ? {'x': e.dx, 'y': e.dy} : null).toList();
      await apiService.saveWhiteboardData(widget.templateId, dataToSave);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Whiteboard saved!",
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.blue[800],
        ),
      );
    } catch (e) {
      print("Error saving whiteboard: $e");
    }
  }

  void _clearWhiteboard() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
          automaticallyImplyLeading: false, 
        title: Text(
          "Whiteboard",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWhiteboard,
            tooltip: "Save",
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearWhiteboard,
            tooltip: "Clear",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      points.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    points.add(null);
                  },
                  child: Container(
                    color: Colors.white,
                    child: CustomPaint(
                      painter: WhiteboardPainter(points),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Text(
              "Draw and save your sketches here.",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<Offset?> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
