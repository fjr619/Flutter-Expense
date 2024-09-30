import 'dart:io';

import 'package:flutter/material.dart';

class WidgetImageItem extends StatelessWidget {
  final String tag;
  final File file;
  final Function()? onTap;
  const WidgetImageItem(
      {super.key, required this.tag, required this.file, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(file),
            // fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(12), // Same as Material's border radius
          onTap: onTap,
          splashColor: Colors.teal.withOpacity(0.3),
        ),
      ),
    );
  }
}
