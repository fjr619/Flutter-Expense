// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';

class HomeState {
  final bool isLoading;
  final double totalValue;
  final Budget? budget;
  final List<Expense> expensesToday;
  final List<Expense> expensesAll;

  double get budgetValue {
    if (budget == null) {
      return 0;
    }

    return budget!.amount!;
  }

  double get percent {
    return (budgetValue > 0) ? totalValue / budgetValue : 0;
  }

  HomeState({
    this.isLoading = false,
    this.totalValue = 0.0,
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
    this.budget,
  })  : expensesToday = expensesToday ?? [],
        expensesAll = expensesAll ?? [];

  HomeState copyWith({
    bool? isLoading,
    double? totalValue,
    Budget? budget,
    List<Expense>? expensesToday,
    List<Expense>? expensesAll,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      totalValue: totalValue ?? this.totalValue,
      budget: budget ?? this.budget,
      expensesToday: expensesToday ?? this.expensesToday,
      expensesAll: expensesAll ?? this.expensesAll,
    );
  }
}
