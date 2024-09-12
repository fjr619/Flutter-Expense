import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_item.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final _expenseformKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate = DateTime.now();

  Future<void> selectDatePicker(DateTime currentDateTime) async {
    final viewModel = ref.read(expenseViewmodelProvider.notifier);
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDateTime,
        firstDate: DateTime(2024),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      viewModel.updateSelectedDate(pickedDate);
    }
  }

  Future<void> selectCategory(int index) async {
    final viewModel = ref.read(expenseViewmodelProvider.notifier);
    viewModel.updateSelectedCategoryIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _expenseformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: amountController,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter amount";
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d*')), // Allow numbers and one decimal point
                  ],
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    hintStyle: TextStyle(fontSize: 14),
                    hintText: "Enter amount",
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        "Rp",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM')
                            .format(expenseState.selectedDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      IconButton(
                          onPressed: () async {
                            await selectDatePicker(expenseState.selectedDate);
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.teal,
                          ))
                    ],
                  ),
                ),
                const WidgetTitle(title: 'Select category', clr: Colors.black),
                const Gap(10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 4),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return WidgetCategoryItem(
                      index: index,
                      selectedCategoryIndex: expenseState.selectedCategoryIndex,
                      onSelected: () async {
                        await selectCategory(index);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
