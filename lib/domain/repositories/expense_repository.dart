import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/repositories/repository.dart';

abstract class ExpenseRepository<T> extends Repository<T> {
  Stream<List<Expense>> getObjectsByToday();
  Stream<double> getSumForCategory(CategoryEnum value);
  Future<List<Expense>> getObjectsByCategory(CategoryEnum value);
  Future<List<Expense>> getObjectsByAmountRange(double lowAmount, double highAmount);
  Future<List<Expense>> getObjectsWithAmountGreaterThan(double amountValue);
  Future<List<Expense>> getObjectsWithAmountLessThan(double amountValue);
  Future<List<Expense>> getObjectsByOptions(CategoryEnum value, double amountHighValue);
  Future<List<Expense>> getObjectsNotOthersCategory();
  Future<List<Expense>> getObjectsByGroupFilter(String searchText, DateTime dateTime);
  Future<List<Expense>> getObjectsBySearchText(String searchText);
  Future<List<Expense>> getObjectsUsingAnyOf(List<CategoryEnum> categories);
  Future<List<Expense>> getObjectsUsingAllOf(List<CategoryEnum> categories);
  Future<List<Expense>> getObjectsWithoutPaymentMethod();
  Future<List<Expense>> getObjectsWithTags(int tags);
  Future<List<Expense>> getObjectsWithTagName(String tagWord);
  Future<List<Expense>> getObjectsBySubCategory(String subCategory);
  Future<List<Expense>> getObjectsByReceipts(String receiptName);
  Future<List<Expense>> getObjectsAndPaginate(int offset);
  Future<List<Expense>> getObjectsWithDistinctValues();
  Future<List<Expense>> getOnlyFirstObject();
  Future<List<Expense>> deleteOnlyFirstObject();
  Future<int> getTotalObjects();
  Future<void> clearData();
  Future<List<String?>> getPaymentProperty();
  Stream<double> totalExpenses();
  Future<double> totalExpensesByCategory();
  Future<List<Expense>> fullTextSearch(String searchText);
}
