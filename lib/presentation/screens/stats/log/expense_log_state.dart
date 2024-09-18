class ExpenseLogState {
  final int countExpense;

  ExpenseLogState({this.countExpense = 0});

  ExpenseLogState copyWith({
    int? countExpense,
  }) {
    return ExpenseLogState(
      countExpense: countExpense ?? this.countExpense,
    );
  }
}
