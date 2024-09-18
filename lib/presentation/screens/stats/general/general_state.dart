import 'package:flutter_expensetracker/domain/models/expense.dart';

class GeneralState {
  final double budgetValue;
  final List<double> categorySum;

  GeneralState({
    this.budgetValue = 0,
    List<double>? categorySum,
  }) : categorySum = categorySum ?? [];

  GeneralState copyWith({
    double? budgetValue,
    List<double>? categorySum,
  }) {
    return GeneralState(
      budgetValue: budgetValue ?? this.budgetValue,
      categorySum: categorySum ?? this.categorySum,
    );
  }
}
