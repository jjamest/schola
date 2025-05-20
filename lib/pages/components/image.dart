import 'package:flutter/material.dart';

// Image widget that can be expanded when a user clicks on it. Useful for most cases
class ClickableImage extends StatefulWidget {
  final String imagePath;

  const ClickableImage({super.key, required this.imagePath});

  @override
  State<ClickableImage> createState() => _ClickableImageState();
}

class _ClickableImageState extends State<ClickableImage> {
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.asset(widget.imagePath),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context),
      child: Image.asset(widget.imagePath),
    );
  }
}
