import 'dart:developer';

import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseViewmodel extends StateNotifier<ExpenseState> {
  ExpenseViewmodel() : super(ExpenseState()) {
    log('init ExpenseViewmodel');
  }

  // Method to update the selected date
  void updateSelectedDate(DateTime newDate) {
    state = state.copyWith(selectedDate: newDate);
  }

  void updateSelectedCategoryIndex(int index) {
    state = state.copyWith(selectedCategoryId: index);
  }

  void reinitialize() {
    log('reinitialize');
    state = state.copyWith(
      selectedDate: DateTime.now(),
      selectedCategoryId: 0,
    );
  }
}
