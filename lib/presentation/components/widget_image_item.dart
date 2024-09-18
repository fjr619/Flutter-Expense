import 'dart:io';

import 'package:flutter/material.dart';

class WidgetImageItem extends StatelessWidget {
  final File file;
  final Function()? onclickItem;
  const WidgetImageItem({super.key, required this.file, this.onclickItem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(12), // Apply border radius to clip the image
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              file,
              fit: BoxFit.cover, // Ensure the image covers the entire area
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent, // Ensure the material is transparent
              child: InkWell(
                borderRadius: BorderRadius.circular(
                    12), // Ensure ripple follows the border radius
                splashColor: Colors.teal.shade100,
                onTap: () {
                  onclickItem?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
