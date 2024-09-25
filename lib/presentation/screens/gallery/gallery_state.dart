// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/receipt.dart';

class GalleryState {
  final List<Receipt> receipts;

  GalleryState({List<Receipt>? receipts}) : receipts = receipts ?? [];

  GalleryState copyWith({
    List<Receipt>? receipts,
  }) {
    return GalleryState(
      receipts: receipts ?? this.receipts,
    );
  }
}
