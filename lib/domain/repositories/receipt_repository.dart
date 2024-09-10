import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/repository.dart';

abstract class ReceiptRepository<T> extends Repository<T> {
  Future<void> uploadReceipts(List<Receipt> receipts);
  Future<List<Receipt>> downloadReceipts();
  Future<void> clearGallery(List<Receipt> receipts);
}
