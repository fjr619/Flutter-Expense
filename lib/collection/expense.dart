import 'package:flutter_expensetracker/collection/receipt.dart';
import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  @Index()
  late double amount;

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  CategoryEnum? category;

  SubCategory? subCategory;

  final receipts = IsarLinks<Receipt>();

  @Index(composite: [CompositeIndex('amount')])
  String? paymentMethod;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String>? description;
}

enum CategoryEnum { bills, foods, clothes, transport, fun, others }

@embedded
class SubCategory {
  String? name;
}
