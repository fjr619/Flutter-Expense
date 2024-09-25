import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_item.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  Amountfilter? groupValue;
  final TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  List<int> selectedItems = [];
  int dropdownValue = 0;
  List<int> numberOfTags = [0, 1, 2, 3, 4, 5];
  int offset = 0;
  Orderfilter? insertionOrder;

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
            filterByAmount(),
            filterByCategoryAndAmount(),
            filterByNotOthersCategory(),
            filterByGroupFilter(context),
            filterByPaymentMethod(),
            filterByAnySelectedCategory(),
            filterByAllSelectedCategory(),
            filterByTags(context),
            filterByTagName(context),
            filterBySubCategory(context),
            filterByReceipt(context),
            filterByPagination(context),
            // filterByInsertion(),
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

  Visibility filterByAmount() {
    final TextEditingController amountController = TextEditingController();

    return Visibility(
        visible: (filterby == Filterby.amount),
        child: Column(
          children: [
            RadioListTile<Amountfilter>(
                activeColor: Colors.teal,
                title: const Text("Greater than"),
                value: Amountfilter.greaterThan,
                groupValue: groupValue,
                onChanged: (Amountfilter? value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            RadioListTile<Amountfilter>(
                activeColor: Colors.teal,
                title: const Text("Less than"),
                value: Amountfilter.lessThan,
                groupValue: groupValue,
                onChanged: (Amountfilter? value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Enter amount'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        amountController.clear();
                        // ref.read(expenseFilterProvider.notifier).clearState();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Reset")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (amountController.text.isNotEmpty) {
                          if (groupValue == Amountfilter.greaterThan) {
                            expenseListVM.filterByAmountGreaterThan(
                                double.parse(amountController.text));
                          } else if (groupValue == Amountfilter.lessThan) {
                            expenseListVM.filterByAmountLessThan(
                                double.parse(amountController.text));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const StadiumBorder(),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            )
          ],
        ));
  }

  Visibility filterByCategoryAndAmount() {
    return Visibility(
      visible: (filterby == Filterby.categoryAndAmount),
      child: Column(
        children: [
          GridView.builder(
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
                  },
                  selectedCategoryIndex: selectedCategoryIndex,
                );
              }),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: TextField(
              controller: amountController,
              decoration: const InputDecoration(
                  hintText: "Amount greater than ...",
                  hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      amountController.clear();
                      setState(() {
                        selectedCategoryIndex = -1;
                      });
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
                      if (selectedCategoryIndex != -1 &&
                          amountController.text.isNotEmpty) {
                        expenseListVM.filterByAmountAndCategory(
                            CategoryEnum.values[selectedCategoryIndex],
                            double.parse(amountController.text));
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

  Visibility filterByNotOthersCategory() {
    return Visibility(
      visible: (filterby == Filterby.notOthers),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
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
                  expenseListVM.filterByNotOthersCategory();
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
      ),
    );
  }

  Visibility filterByGroupFilter(BuildContext context) {
    return Visibility(
        visible: (filterby == Filterby.groupFilter),
        child: Column(
          children: [
            const Text("Category: Others"),
            ListTile(
                subtitle: Text(DateFormat("d MMM yyyy").format(selectedDate)),
                trailing: IconButton(
                    onPressed: () async {
                      selectedDate = (await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030))) ??
                          DateTime.now();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.teal,
                    ))),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search text",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.teal)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        selectedDate = DateTime.now();
                        searchController.clear();
                        expenseListVM.resetExpenseFilter();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Reset")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (searchController.text.isNotEmpty) {
                          expenseListVM.filterByGroupFilter(
                              searchController.text, selectedDate);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const StadiumBorder(),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Apply"))
                ],
              ),
            ),
          ],
        ));
  }

  Visibility filterByPaymentMethod() {
    return Visibility(
        visible: (filterby == Filterby.paymentMethod),
        child: TextField(
          controller: searchController,
          onChanged: (String? value) {
            if (value == null) {
              expenseListVM.resetExpenseFilter();
            } else {
              expenseListVM.filterByPaymentMethod(value);
            }
          },
        ));
  }

  Visibility filterByAnySelectedCategory() {
    return Visibility(
        visible: (filterby == Filterby.anySelectedCategory),
        child: Column(children: [
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4.0),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(index)) {
                        selectedItems.remove(index);
                      } else {
                        selectedItems.add(index);
                      }
                    });
                  },
                  child: Card(
                    color: selectedItems.contains(index)
                        ? const Color(0xFFA4D6D1)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/${categories[index]["icon"]!}",
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            categories[index]["name"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedItems.contains(index)
                                    ? Colors.teal
                                    : const Color.fromRGBO(155, 162, 161, 1),
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                    expenseListVM.resetExpenseFilter();
                  },
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 30)),
                  child: const Text("Reset"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      List<CategoryEnum> categories = [];
                      for (int selectedItem in selectedItems) {
                        categories.add(CategoryEnum.values[selectedItem]);
                      }

                      expenseListVM.filterByUsingAny(categories);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Apply"))
              ]))
        ]));
  }

  Visibility filterByAllSelectedCategory() {
    return Visibility(
        visible: (filterby == Filterby.allSelectedCategory),
        child: Column(children: [
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4.0),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(index)) {
                        selectedItems.remove(index);
                      } else {
                        selectedItems.add(index);
                      }
                    });
                  },
                  child: Card(
                    color: selectedItems.contains(index)
                        ? const Color(0xFFA4D6D1)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/${categories[index]["icon"]!}",
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            categories[index]["name"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedItems.contains(index)
                                    ? Colors.teal
                                    : const Color.fromRGBO(155, 162, 161, 1),
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                    expenseListVM.resetExpenseFilter();
                  },
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 30)),
                  child: const Text("Reset"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      List<CategoryEnum> categories = [];
                      for (int selectedItem in selectedItems) {
                        categories.add(CategoryEnum.values[selectedItem]);
                      }

                      expenseListVM.filterByUsingAll(categories);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Apply"))
              ]))
        ]));
  }

  Visibility filterByTags(BuildContext context) {
    return Visibility(
      visible: (filterby == Filterby.tags),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Number of tags:"),
            const Spacer(),
            DropdownButton<int>(
              value: dropdownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              style: const TextStyle(color: Colors.teal),
              underline: Container(
                height: 2,
                color: Colors.teal,
              ),
              onChanged: (int? value) {
                setState(() {
                  dropdownValue = value!;
                });
                expenseListVM.filterbyTags(dropdownValue);
              },
              items: numberOfTags.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Visibility filterByTagName(BuildContext context) {
    return Visibility(
        visible: (filterby == Filterby.tagName),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: "Search tag",
                    hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    expenseListVM.filterByTagName(searchController.text);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.teal,
                ))
          ],
        ));
  }

  Visibility filterBySubCategory(BuildContext context) {
    return Visibility(
        visible: (filterby == Filterby.subcat),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: "Search sub category",
                    hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    expenseListVM.filterBySubCategory(searchController.text);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.teal,
                ))
          ],
        ));
  }

  Visibility filterByReceipt(BuildContext context) {
    return Visibility(
        visible: (filterby == Filterby.receipt),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: "Search Receipt name",
                    hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    expenseListVM.filterByReceipt(searchController.text);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.teal,
                ))
          ],
        ));
  }

  Visibility filterByPagination(BuildContext context) {
    log("offset $offset");
    return Visibility(
        visible: (filterby == Filterby.pagination),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                expenseListVM.filterByPagination(offset);
                setState(() {
                  offset += 3;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const StadiumBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 30)),
              child: const Text("Display items (3 items)")),
        ));
  }

  Visibility filterByInsertion() {
    return Visibility(
      visible: (filterby == Filterby.insertion),
      child: Column(
        children: [
          RadioListTile<Orderfilter>(
              activeColor: Colors.teal,
              title: const Text("Find first"),
              value: Orderfilter.findfirst,
              groupValue: insertionOrder,
              onChanged: (Orderfilter? value) {
                setState(() {
                  insertionOrder = value!;
                });
                expenseListVM.filterByFindingFirst();
              }),
          RadioListTile<Orderfilter>(
              activeColor: Colors.teal,
              title: const Text("Delete first"),
              value: Orderfilter.deletefirst,
              groupValue: insertionOrder,
              onChanged: (Orderfilter? value) {
                setState(() {
                  insertionOrder = value!;
                });
                expenseListVM.filterByDeletingFirst();
              }),
        ],
      ),
    );
  }
}
