import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_item.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/presentation/screens/expense_list/expense_list_screen.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final int type;
  const FilterScreen({super.key, required this.type});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  late String filter;
  late Filterby filterby;
  late final expenseListVM = ref.read(expenseListViewmodelProvider.notifier);

  int selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    filter = filterOptions[widget.type];
    filterby = Filterby.values[widget.type];
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseListViewmodelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                'Filter by $filter',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.teal, // White text for AppBar
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.cancel, size: 30, color: Colors.teal),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: ListView(
          children: [
            filterByCategory(),
            filterByAmountRange(),
            const Gap(16),
            const Text(
              "Results",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            WidgetExpenseListWithFilter(
              expensesFilter: expenseState.expensesFilter,
            )
          ],
        ),
      ),
    );
  }

  Visibility filterByCategory() {
    return Visibility(
      visible: (filterby == Filterby.category),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            return WidgetCategoryItem(
              index: index,
              onSelected: () {
                setState(() {
                  selectedCategoryIndex = index;
                });
                expenseListVM.filterByCategory(CategoryEnum.values[index]);
              },
              selectedCategoryIndex: selectedCategoryIndex,
            );
          }),
    );
  }

  Visibility filterByAmountRange() {
    final filterformKey = GlobalKey<FormState>();
    final TextEditingController lowValueController = TextEditingController();
    final TextEditingController highValueController = TextEditingController();

    return Visibility(
      visible: (filterby == Filterby.amountrange),
      child: Column(
        children: [
          Form(
            key: filterformKey,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: lowValueController,
                        decoration:
                            const InputDecoration(hintText: "Low value"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter low amount';
                          }
                          return null;
                        },
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: highValueController,
                        decoration:
                            const InputDecoration(hintText: "High value"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter high amount';
                          }
                          return null;
                        },
                      ))
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      lowValueController.clear();
                      highValueController.clear();
                      expenseListVM.resetExpenseFilter();
                    },
                    style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Reset")),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (filterformKey.currentState!.validate()) {
                        expenseListVM.filterByAmountRange(
                            double.parse(lowValueController.text),
                            double.parse(highValueController.text));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
