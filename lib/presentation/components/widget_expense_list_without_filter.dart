import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/util/util.dart';

class WidgetExpenseListWithoutFilter extends StatelessWidget {
  final List<Expense> expenses;

  const WidgetExpenseListWithoutFilter({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final Expense expense = expenses[index];

          return Row(
            children: [
              Image.asset(
                'assets/images/${categories[expense.category!.index]['icon']}',
                width: 30,
              ),
              Flexible(
                child: ListTile(
                  title: Text(
                    categories[expense.category!.index]['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Text(
                    '${expense.amount}',
                    style: const TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
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
