import 'dart:io';

import 'package:path_provider/path_provider.dart';

const List<Map<String, dynamic>> categories = [
  {"name": "Bills", "icon": "bill.png", "selected": false},
  {"name": "Food", "icon": "food.png", "selected": false},
  {"name": "Clothes", "icon": "clothes.png", "selected": false},
  {"name": "Transport", "icon": "transport.png", "selected": false},
  {"name": "Fun", "icon": "fun.png", "selected": false},
  {"name": "Others", "icon": "others.png", "selected": false}
];

const List<String> paymentMethodsDummy = [
  "Cash",
  "Credit card",
  "Bank account"
];

Future<String> getPath() async {
  Directory appDir = await getApplicationDocumentsDirectory();
  return appDir.path;
}
