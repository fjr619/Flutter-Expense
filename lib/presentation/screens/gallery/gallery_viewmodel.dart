import 'dart:async';

import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/gallery/gallery_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryViewmodel extends StateNotifier<GalleryState> {
  final ReceiptRepository<Receipt> receiptRepository;
  GalleryViewmodel({required this.receiptRepository}) : super(GalleryState()) {
    getAllReceipt();
  }

  StreamSubscription<List<Receipt>>? _receiptsSubscription;

  void getAllReceipt() async {
    _receiptsSubscription?.cancel();

    _receiptsSubscription = receiptRepository.getAllObjects().listen(
      (event) {
        state = state.copyWith(receipts: event);
      },
    );
  }

  void clearAllReceipt() async {
    receiptRepository.clearGallery();
  }

  @override
  void dispose() {
    _receiptsSubscription?.cancel();
    super.dispose();
  }
}
