import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/income.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  late Isar _isar;

  // Singleton pattern to ensure only one instance of Isar
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open([BudgetSchema, ExpenseSchema, ReceiptSchema, IncomeSchema],
          directory: dir.path, name: 'expenseInstance');
    }
    _isar = Isar.getInstance('expenseInstance')!;
  }

  Isar get isar => _isar;
}
