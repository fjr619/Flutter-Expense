import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:isar/isar.dart';

class ExpenseRepositoryImpl extends ExpenseRepository<Expense> {
  final Isar isar; // Injected Isar instance

  ExpenseRepositoryImpl(this.isar); // Constructor injection of Isar

  @override
  Future<void> createMultipleObjects(List<Expense> collections) async {
    await isar.writeTxn(() async {
      await isar.expenses.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(collection);
      await collection.receipts.save();
    });
  }

  @override
  Future<void> deletObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(collection.id);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.expenses.deleteAll(ids);
  }

  @override
  Stream<List<Expense>> getAllObjects() {
    return isar.expenses
        .where(sort: Sort.desc)
        .anyId()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<Expense?> getObjectById(int id) async {
    return await isar.expenses.get(id);
  }

  @override
  Future<List<Expense?>> getObjectsById(List<int> ids) async {
    return await isar.expenses.getAll(ids);
  }

  @override
  Future<void> updateObject(Expense collection) async {
    await isar.writeTxn(() async {
      final budget = await isar.expenses.get(collection.id);

      if (budget != null) {
        await isar.expenses.put(collection);
      }
    });
  }

  @override
  Stream<List<Expense>> getObjectsByToday() {
    return isar.expenses
        .where(sort: Sort.desc)
        .anyId()
        .filter()
        .dateEqualTo(DateTime.now().copyWith(
            hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0))
        .watch(fireImmediately: true);
  }

  @override
  Stream<double> getSumForCategory(CategoryEnum value) {
    return isar.expenses
        .filter()
        .categoryEqualTo(value)
        .amountProperty()
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => isar.expenses
            .filter()
            .categoryEqualTo(value)
            .amountProperty()
            .sum());
  }

  @override
  Future<List<Expense>> getObjectsByCategory(CategoryEnum value) async {
    return await isar.expenses.filter().categoryEqualTo(value).findAll();
  }

  @override
  Future<List<Expense>> getObjectsByAmountRange(
      double lowAmount, double highAmount) async {
    return await isar.expenses
        .filter()
        .amountBetween(lowAmount, highAmount, includeLower: false)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithAmountGreaterThan(
      double amountValue) async {
    return await isar.expenses
        .filter()
        .amountGreaterThan(amountValue)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithAmountLessThan(double amountValue) async {
    return await isar.expenses.filter().amountLessThan(amountValue).findAll();
  }

  @override
  Future<List<Expense>> getObjectsByOptions(
      CategoryEnum value, double amountHighValue) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(value)
        .and()
        .amountGreaterThan(amountHighValue)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsNotOthersCategory() async {
    return await isar.expenses
        .filter()
        .not()
        .categoryEqualTo(CategoryEnum.others)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsByGroupFilter(
      String searchText, DateTime dateTime) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(CategoryEnum.others)
        .group((q) => q
            .paymentMethodContains(searchText, caseSensitive: false)
            .and()
            .dateEqualTo(dateTime))
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsBySearchText(String searchText) async {
    return await isar.expenses
        .filter()
        .paymentMethodStartsWith(searchText, caseSensitive: false)
        .or()
        .paymentMethodEndsWith(searchText, caseSensitive: false)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsUsingAnyOf(
      List<CategoryEnum> categories) async {
    return await isar.expenses
        .filter()
        .anyOf(categories, (q, CategoryEnum cat) => q.categoryEqualTo(cat))
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsUsingAllOf(
      List<CategoryEnum> categories) async {
    return await isar.expenses
        .filter()
        .allOf(categories, (q, CategoryEnum cat) => q.categoryEqualTo(cat))
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithoutPaymentMethod() async {
    return await isar.expenses.filter().paymentMethodIsEmpty().findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithTags(int tags) async {
    return await isar.expenses
        .filter()
        .descriptionLengthEqualTo(tags)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithTagName(String tagWord) async {
    return await isar.expenses
        .filter()
        .descriptionElementEqualTo(tagWord, caseSensitive: false)
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsBySubCategory(String subCategory) async {
    return await isar.expenses
        .filter()
        .subCategory((q) => q.nameEqualTo(subCategory))
        .findAll();
  }

  @override
  Future<List<Expense>> getObjectsByReceipts(String receiptName) async {
    return await isar.expenses.filter().receipts((q) {
      return q.nameEqualTo(receiptName).or().nameContains(receiptName);
    }).findAll();
  }

  @override
  Future<List<Expense>> getObjectsAndPaginate(int offset) async {
    return await isar.expenses.where().offset(offset).limit(3).findAll();
  }

  @override
  Future<List<Expense>> getObjectsWithDistinctValues() async {
    return await isar.expenses.where().distinctByCategory().findAll();
  }

  @override
  Future<List<Expense>> getOnlyFirstObject() async {
    List<Expense> querySelected = [];

    await isar.expenses.where().findFirst().then((value) {
      if (value != null) {
        querySelected.add(value);
      }
    });

    return querySelected;
  }

  @override
  Future<List<Expense>> deleteOnlyFirstObject() async {
    await isar.writeTxn(() async {
      await isar.expenses.where().deleteFirst();
    });

    return await isar.expenses.where().findAll();
  }

  @override
  Stream<int> getTotalObjects() {
    return isar.expenses.watchLazy(fireImmediately: true).asyncMap((_) async {
      return await isar.expenses.where().count();
    });
  }

  @override
  Future<void> clearData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  @override
  Future<List<String?>> getPaymentProperty() async {
    return await isar.expenses.where().paymentMethodProperty().findAll();
  }

  @override
  Stream<double> totalExpenses() {
    return isar.expenses
        .where()
        .amountProperty()
        .watchLazy(
            fireImmediately:
                true) // Lazily watch for changes but don't re-run the query
        .asyncMap((_) => isar.expenses
            .where()
            .amountProperty()
            .sum()); // Re-run query manually when changes are detected
  }

  @override
  Future<double> totalExpensesByCategory() async {
    return await isar.expenses
        .where()
        .distinctByCategory()
        .amountProperty()
        .sum();
  }

  @override
  Future<List<Expense>> fullTextSearch(String searchText) async {
    return await isar.expenses
        .filter()
        .descriptionElementEqualTo(searchText)
        .or()
        .descriptionElementStartsWith(searchText)
        .or()
        .descriptionElementEndsWith(searchText)
        .or()
        .subCategory((sub) => sub.nameContains(searchText,
            caseSensitive: false)) // Search in subcategory name
        .findAll();

    //another way to do this!!
    // return await isar.expenses
    //     .filter()
    //     .descriptionElementContains(searchText)
    //     .find
  }
}
