import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expensetracker/lib_empty_widget/images.dart';
import 'package:flutter_expensetracker/lib_empty_widget/empty.dart';

class WidgetEmpty extends StatelessWidget {
  final String subtitle;
  const WidgetEmpty({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: EmptyWidget(
        hideBackgroundAnimation: true,
        image: null,
        packageImage: PackageImage.Image_1,
        subTitle: subtitle,
        subtitleTextStyle: const TextStyle(color: Colors.teal),
      ),
    );
  }
}
