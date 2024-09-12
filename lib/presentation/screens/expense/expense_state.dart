// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseState {
  final DateTime selectedDate;
  final int selectedCategoryIndex;

  ExpenseState({
    DateTime? selectedDate,
    this.selectedCategoryIndex = 0,
  }) : selectedDate = selectedDate ?? DateTime.now();

  ExpenseState copyWith({
    DateTime? selectedDate,
    int? selectedCategoryId,
  }) {
    return ExpenseState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategoryIndex: selectedCategoryId ?? selectedCategoryIndex,
    );
  }
}
