class ExpenseState {
  final double amount;
  final bool doValidationAmount;

  final DateTime selectedDate;
  final int selectedCategoryIndex;

  final String? selectedPayment;

  final String subCat;
  final bool doValidationSubCat;
  final List<Map<String, dynamic>> receiptDatas;
  final List<String>? tags;

  ExpenseState({
    this.amount = 0,
    DateTime? selectedDate,
    this.selectedCategoryIndex = 0,
    this.doValidationAmount = false,
    this.selectedPayment,
    this.subCat = "",
    this.doValidationSubCat = false,
    List<Map<String, dynamic>>? receiptDatas,
    this.tags,
  })  : selectedDate = selectedDate ?? DateTime.now(),
        receiptDatas = receiptDatas ?? [];

  ExpenseState copyWith({
    double? amount,
    bool? doValidationAmount,
    DateTime? selectedDate,
    int? selectedCategoryIndex,
    String? selectedPayment,
    String? subCat,
    bool? doValidationSubCat,
    List<Map<String, dynamic>>? receiptDatas,
    List<String>? tags,
  }) {
    return ExpenseState(
      amount: amount ?? this.amount,
      doValidationAmount: doValidationAmount ?? this.doValidationAmount,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      subCat: subCat ?? this.subCat,
      doValidationSubCat: doValidationSubCat ?? this.doValidationSubCat,
      receiptDatas: receiptDatas ?? this.receiptDatas,
      tags: tags ?? this.tags,
    );
  }

  factory ExpenseState.reset() {
    return ExpenseState(
        amount: 0,
        selectedDate: DateTime.now(),
        selectedCategoryIndex: 0,
        doValidationAmount: false,
        selectedPayment: null,
        subCat: '',
        doValidationSubCat: false,
        receiptDatas: [],
        tags: []);
  }
}
