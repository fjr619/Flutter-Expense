// Define the Isar provider
import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/income.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open([BudgetSchema, ExpenseSchema, ReceiptSchema, IncomeSchema],
        directory: dir.path, name: 'expenseInstance');
  }
  return Isar.getInstance('expenseInstance')!;
});
