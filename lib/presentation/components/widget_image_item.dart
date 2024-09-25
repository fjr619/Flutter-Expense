import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_image_viewer.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:go_router/go_router.dart';

class WidgetImageItem extends StatelessWidget {
  final String tag;
  final File file;
  const WidgetImageItem({super.key, required this.tag, required this.file});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: ImageViewer.file(
          disposeLevel: DisposeLevel.medium,
          tag: tag,
          file: file,
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          openFullScreenViewer: (data) {
            context.pushNamed('fullScreenViewer', extra: data);
          },
        ),
      ),
    );
  }
}
