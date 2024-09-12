// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_expensetracker/domain/models/budget.dart';

class HomeState {
  final bool isLoading;
  final double totalValue;
  final Budget? budget;

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
    this.budget,
  });

  HomeState copyWith({
    bool? isLoading,
    double? totalValue,
    Budget? budget,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      totalValue: totalValue ?? this.totalValue,
      budget: budget ?? this.budget,
    );
  }
}
