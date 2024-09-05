import 'package:flutter_expensetracker/collection/receipt.dart';
import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  late double amount;
  late DateTime date;

  @Enumerated(EnumType.name)
  CategoryEnum? category;

  SubCategory? subCategory;

  Receipt? receipt;

  String? paymentMethod;

  List<String>? description;
}

enum CategoryEnum { bills, foods, clothes, transport, fun, others }

@embedded
class SubCategory {
  String? name;
}
