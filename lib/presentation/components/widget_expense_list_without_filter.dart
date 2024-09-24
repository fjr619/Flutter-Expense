import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                goToDetail(context, expense);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/${categories[expense.category!.index]['icon']}',
                      width: 30,
                    ),
                    Flexible(
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 16),
                        title: Text(
                          categories[expense.category!.index]['name'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.subCategory!.name!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.teal,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              DateFormat(DateFormat.YEAR_MONTH_DAY)
                                  .format(expense.date),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        trailing: Text(
                          '${expense.amount}',
                          style: const TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
