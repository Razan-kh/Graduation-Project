
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// Function to show the emoji picker dialog
Future<String?> chooseEmoji(BuildContext context) async {
  String? selectedEmoji = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Choose an Emoji"),
        content: SingleChildScrollView(
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              Navigator.of(context).pop(emoji.emoji);
            },
            // You can customize the emoji picker appearance here
            config: Config(
            
            ),
          ),
        ),
      );
    },
  );
  return selectedEmoji;
}

