import 'package:flutter/material.dart';

class WidgetDivier extends StatelessWidget {
  final double indent;
  final double endIndent;
  const WidgetDivier({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Divider(
        thickness: 1.0,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
