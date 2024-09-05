
import 'package:flutter_expensetracker/collection/expense.dart';
import 'package:isar/isar.dart';


part 'receipt.g.dart';

@collection
class Receipt {
  Id id = Isar.autoIncrement;

  late String name;

  Expense? expense;
}