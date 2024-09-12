import 'package:flutter_expensetracker/domain/models/income.dart';
import 'package:flutter_expensetracker/domain/repositories/income_repository.dart';
import 'package:isar/isar.dart';

class IncomeRepositoryImpl extends IncomeRepository<Income> {
  final Isar isar; // Injected Isar instance

  IncomeRepositoryImpl(this.isar); // Constructor injection of Isar

  @override
  Future<void> createMultipleObjects(List<Income> collections) async {
    await isar.writeTxn(() async {
      await isar.incomes.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Income collection) async {
    await isar.writeTxn(() async {
      await isar.incomes.put(collection);
    });
  }

  @override
  Future<void> deletObject(Income collection) async {
    await isar.writeTxn(() async {
      await isar.incomes.delete(collection.id);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.incomes.deleteAll(ids);
  }

  @override
  Stream<List<Income>> getAllObjects() {
    return isar.incomes.where().watch();
  }

  @override
  Future<Income?> getObjectById(int id) async {
    return await isar.incomes.get(id);
  }

  @override
  Future<List<Income?>> getObjectsById(List<int> ids) async {
    return await isar.incomes.getAll(ids);
  }

  @override
  Future<void> updateObject(Income collection) async {
    await isar.writeTxn(() async {
      final budget = await isar.incomes.get(collection.id);

      if (budget != null) {
        await isar.incomes.put(collection);
      }
    });
  }
}
