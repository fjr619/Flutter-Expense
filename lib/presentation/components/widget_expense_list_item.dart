import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class WidgetExpenseListItem extends StatelessWidget {
  final Expense expense;
  const WidgetExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}
