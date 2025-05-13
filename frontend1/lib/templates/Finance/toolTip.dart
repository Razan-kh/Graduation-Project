import 'package:flutter/material.dart';

class toolTip extends StatefulWidget {
  @override
 toolTipState createState() => toolTipState();
}

class toolTipState extends State<toolTip> {
  bool _showTooltip = false;
  final GlobalKey _iconKey = GlobalKey(); // Key for the icon
  Offset? _iconPosition;

  @override
  void initState() {
    super.initState();
    _checkTooltipStatus();
  }

  Future<void> _checkTooltipStatus() async {
    bool hasShownTooltip =  false;

    if (!hasShownTooltip) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateIconPosition();
        setState(() {
          _showTooltip = true;
        });
      });

     
    }
  }

  void _calculateIconPosition() {
    RenderBox? renderBox = _iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset position = renderBox.localToGlobal(Offset.zero);
      setState(() {
        _iconPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Page"),
        actions: [
          IconButton(
            key: _iconKey, // Assign the key to the icon
            icon: Icon(Icons.info),
            onPressed: () {
              print("Icon tapped");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text("This is your page content."),
          ),
          if (_showTooltip && _iconPosition != null)
            Positioned(
              top: _iconPosition!.dy -30, // Adjust position below the icon
              left: _iconPosition!.dx -100, // Center align with the icon
              child: TooltipOverlay(
                message: "Tap here for info!",
                onDismiss: () {
                  setState(() {
                    _showTooltip = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TooltipOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  TooltipOverlay({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}