import 'package:flutter/widgets.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';

class WidgetExpenseListWithFilter extends StatelessWidget {
  final List<Expense> expensesFilter;
  const WidgetExpenseListWithFilter({super.key, required this.expensesFilter});

  @override
  Widget build(BuildContext context) {
    return Text("data list ${expensesFilter.length}");
  }
}
