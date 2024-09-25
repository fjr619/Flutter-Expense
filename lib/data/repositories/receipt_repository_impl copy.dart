import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:isar/isar.dart';

class ReceiptRepositoryImpl extends ReceiptRepository<Receipt> {
  final Isar isar; // Injected Isar instance

  ReceiptRepositoryImpl(this.isar); // Constructor injection of Isar

  @override
  Future<void> createMultipleObjects(List<Receipt> collections) async {
    await isar.writeTxn(() async {
      await isar.receipts.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Receipt collection) async {
    await isar.writeTxn(() async {
      await isar.receipts.put(collection);
    });
  }

  @override
  Future<void> deletObject(Receipt collection) async {
    await isar.writeTxn(() async {
      await isar.receipts.delete(collection.id);
    });
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.receipts.deleteAll(ids);
  }

  @override
  Stream<List<Receipt>> getAllObjects() {
    return isar.receipts.where().watch(fireImmediately: true);
  }

  @override
  Future<Receipt?> getObjectById(int id) async {
    return await isar.receipts.get(id);
  }

  @override
  Future<List<Receipt?>> getObjectsById(List<int> ids) async {
    return await isar.receipts.getAll(ids);
  }

  @override
  Future<void> updateObject(Receipt collection) async {
    await isar.writeTxn(() async {
      final budget = await isar.receipts.get(collection.id);

      if (budget != null) {
        await isar.receipts.put(collection);
      }
    });
  }

  @override
  Future<void> uploadReceipts(List<Receipt> receipts) async {
    await isar.writeTxn(() async {
      for (Receipt receipt in receipts) {
        await isar.receipts.put(receipt);
      }
    });
  }

  @override
  Future<List<Receipt>> downloadReceipts() async {
    int totalReceipts = await isar.receipts.where().count();

    List<Receipt> all = [];
    await isar.txn(() async {
      for (int i = 1; i < totalReceipts; i++) {
        final receipt = await isar.receipts.where().idEqualTo(i).findFirst();
        if (receipt != null) {
          all.add(receipt);
        }
      }
    });

    return all;
  }

  @override
  Future<void> clearGallery(List<Receipt> receipts) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < receipts.length; i++) {
        await isar.receipts.delete(receipts[i].id);
      }
    });
  }
}
