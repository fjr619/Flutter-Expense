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

List<String> filterOptions = [
  "Category",
  "Amount Range",
  "Amount",
  "Category and Amount",
  "Not Others Category",
  "Group Filter",
  "Payment Method",
  "Any Selected Category",
  "All Selected Category",
  "Tags",
  "Tag Name",
  "Sub Category",
  "Receipt",
  "Pagination",
  "Insertion"
];

enum Filterby {
  category,
  amountrange,
  amount,
  categoryAndAmount,
  notOthers,
  groupFilter,
  paymentMethod,
  anySelectedCategory,
  allSelectedCategory,
  tags,
  tagName,
  subcat,
  receipt,
  pagination,
  insertion
}

enum Amountfilter { greaterThan, lessThan }

enum Orderfilter { findfirst, deletefirst }

// Extension on Filterby for converting enum to string
extension FilterbyExtension on Filterby {
  String get toShortString =>
      name; // Converts enum to string using name property
}

// Extension on String for converting string to enum
extension StringToFilterby on String {
  Filterby get toFilterbyEnum {
    try {
      return Filterby.values.firstWhere((e) => e.name == this);
    } catch (e) {
      return Filterby.category; // Return null if no match is found
    }
  }
}
