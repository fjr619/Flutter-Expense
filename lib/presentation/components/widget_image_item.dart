import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_full_image.dart';

class WidgetImageItem extends StatelessWidget {
  final File file;
  final Function()? onclickItem;
  const WidgetImageItem({super.key, required this.file, this.onclickItem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: InstaImageViewer(
          tag: "image-${file.path}",
          child: Image.file(
            file,
            // fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
