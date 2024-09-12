import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

//from 14:13, 19:09
class Header extends StatelessWidget {
  final double percent;
  final double totalValue;
  final double budgetValue;
  final Function(double amount) submitBudget;

  final TextEditingController budgetController = TextEditingController();

  Header({
    super.key,
    required this.percent,
    required this.totalValue,
    required this.budgetValue,
    required this.submitBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Budget',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        content: TextField(
                          cursorColor: Colors.teal,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'^\d+\.?\d*')), // Allow numbers and one decimal point
                          ],
                          controller: budgetController,
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
                },
                child: const Text(
                  'Create Budget',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
