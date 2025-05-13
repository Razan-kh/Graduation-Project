/*
import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  final Widget child;

  ResizableWidget({required this.child});

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  double width = 200;
  double height = 200;
  late Offset dragStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // Capture the starting position of the drag
        dragStart = details.localPosition;
      },
      onPanUpdate: (details) {
        // Calculate the change in size based on drag movement
        setState(() {
          width += details.localPosition.dx - dragStart.dx;
          height += details.localPosition.dy - dragStart.dy;

          // Make sure the width and height don't become negative
          width = width > 100 ? width : 100;
          height = height > 100 ? height : 100;

          dragStart = details.localPosition; // Update the start position for the next update
        });
      },
      child: Stack(
        children: [
          widget.child,
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  width += details.localPosition.dx;
                  height += details.localPosition.dy;
                });
              },
              child: Icon(Icons.crop_square, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
*/