import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_item.dart';

class WidgetExpenseListWithoutFilter extends StatelessWidget {
  final List<Expense> expenses;
  final bool canScroll;
  final Future<void> Function(Expense) onDissmissed;

  const WidgetExpenseListWithoutFilter(
      {super.key,
      required this.expenses,
      required this.canScroll,
      required this.onDissmissed});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: !canScroll ? const NeverScrollableScrollPhysics() : null,
        itemBuilder: (context, index) {
          final Expense expense = expenses[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(color: Colors.teal),
            secondaryBackground: Container(
              color: Colors.teal,
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "DELETE",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ),
            onDismissed: (direction) async {
              await onDissmissed(expense);
            },
            child: WidgetExpenseListItem(expense: expense),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.teal,
            thickness: 0.5,
            indent: 40,
          );
        },
        itemCount: expenses.length);
  }
}
