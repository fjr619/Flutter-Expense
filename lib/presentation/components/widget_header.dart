import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WidgetHeader extends StatelessWidget {
  final double percent;
  final double totalValue;
  final double budgetValue;
  final bool hasBudget;
  final Function(double amount) submitBudget;

  final TextEditingController budgetController = TextEditingController();

  WidgetHeader({
    super.key,
    required this.percent,
    required this.totalValue,
    required this.budgetValue,
    required this.hasBudget,
    required this.submitBudget,
  });

  void showDialogBudget(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String displayValue =
            (budgetValue == 0.0) ? '' : budgetValue.toString();

        return AlertDialog(
          title: const Text(
            'Budget',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            cursorColor: Colors.teal,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d*')), // Allow numbers and one decimal point
            ],
            controller: budgetController..text = displayValue,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
              hintStyle: TextStyle(fontSize: 14),
              hintText: "Enter amount",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop();
                submitBudget(double.parse(budgetController.text));
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    ).then(
      (_) => budgetController.clear(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(
      () => budgetController.text = budgetValue.toString(),
    );

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                DateFormat.MMM().format(DateTime.now()),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.teal),
              ),
              subtitle: Text(
                DateTime.now().year.toString(),
                style: const TextStyle(color: Colors.teal),
              ),
            ),
            SizedBox(
              child: CircularPercentIndicator(
                radius: 80,
                lineWidth: 30,
                progressColor: Colors.teal,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                percent: percent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RichText(
                text: TextSpan(
                  text: totalValue.toString(),
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    const TextSpan(
                      text: '/',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: budgetValue.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                  side: WidgetStateProperty.resolveWith<BorderSide>(
                (states) => const BorderSide(color: Colors.teal),
              )),
              onPressed: () {
                showDialogBudget(context);
              },
              child: Text(
                (hasBudget) ? 'Edit Budget' : 'Create Budget',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
