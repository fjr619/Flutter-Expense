import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/repositories/repository.dart';

abstract class BudgetRepository<T> extends Repository<T> {
  Future<Budget?> getObjectByDate({required int month, required int year});
}
