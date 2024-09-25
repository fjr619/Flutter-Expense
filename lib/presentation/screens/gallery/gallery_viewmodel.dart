import 'dart:async';
import 'dart:developer';

import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/gallery/gallery_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryViewmodel extends StateNotifier<GalleryState> {
  final ReceiptRepository<Receipt> receiptRepository;
  GalleryViewmodel({required this.receiptRepository}) : super(GalleryState()) {
    log("== inti gallery vm");
    getAllReceipt();
  }

  StreamSubscription<List<Receipt>>? _receiptsSubscription;

  void getAllReceipt() async {
    _receiptsSubscription?.cancel();

    _receiptsSubscription = receiptRepository.getAllObjects().listen(
      (event) {
        log("==getallreceipt ${event.length}");
        state = state.copyWith(receipts: event);
      },
    );
  }

  @override
  void dispose() {
    _receiptsSubscription?.cancel();
    super.dispose();
  }
}
