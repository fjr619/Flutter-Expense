// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/expense.dart';

class DetailState {
  final Expense? expense;

  DetailState({this.expense});

  DetailState copyWith({
    Expense? expense,
  }) {
    return DetailState(
      expense: expense ?? this.expense,
    );
  }
}
