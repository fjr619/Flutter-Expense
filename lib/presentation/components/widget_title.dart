import 'package:flutter/widgets.dart';

class WidgetTitle extends StatelessWidget {
  const WidgetTitle({super.key, required this.title, required this.clr});

  final String title;
  final Color clr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: clr),
      ),
    );
  }
}
