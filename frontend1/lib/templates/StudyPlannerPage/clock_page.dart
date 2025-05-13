import 'package:flutter/material.dart';
import 'dart:async';

class FlipClockWidget extends StatefulWidget {
  const FlipClockWidget({super.key});

  @override
  _FlipClockWidgetState createState() => _FlipClockWidgetState();
}

class _FlipClockWidgetState extends State<FlipClockWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    // Set up timer to update the clock every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _now = DateTime.now();
        _controller.forward(from: 0.0);  // Only start the animation once per minute
      });
    });

    // Set up animation controller for the flip animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildFlipCard(_now.hour.toString().padLeft(2, '0')),
        SizedBox(width: 8),
        buildFlipCard(_now.minute.toString().padLeft(2, '0')),
        SizedBox(width: 8),
        Column(
          children: [
            buildLabel(_now.hour >= 12 ? 'PM' : 'AM'),
            buildLabel(_getWeekday(_now.weekday)),
          ],
        ),
      ],
    );
  }

  Widget buildFlipCard(String time) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final flipValue = _controller.value;
        // Split the animation into two phases: flipping up and flipping down
        final flipAngle = flipValue < 0.5 ? flipValue * 3.14 : (1 - flipValue) * 3.14;

        return Transform(
          transform: Matrix4.rotationX(flipAngle),
          alignment: Alignment.center,
          child: Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"
    ];
    return weekdays[weekday - 1];
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey[600],
      ),
    );
  }
}
