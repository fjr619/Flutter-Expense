import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WidgetCategoryStats extends StatelessWidget {
  final double budgetValue;
  final List<double> categoriesSum;
  const WidgetCategoryStats(
      {super.key, required this.budgetValue, required this.categoriesSum});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WidgetTitle(title: 'Expenses / Category', clr: Colors.teal),
        const Gap(10),
        if (budgetValue > 0 && categoriesSum.isNotEmpty) ...[
          for (int i = 0; i < categories.length; i++)
            LinearPercentIndicator(
              barRadius: const Radius.circular(8),
              animation: true,
              width: 140,
              lineHeight: 7,
              percent: categoriesSum[i] / budgetValue,
              backgroundColor: const Color.fromARGB(255, 214, 218, 217),
              progressColor: Colors.teal,
              trailing: Text(categories[i]["name"]),
            )
        ] else
          const SizedBox(
              height: 200, child: WidgetEmpty(subtitle: 'No Expenses')),
      ],
    );
  }
}
