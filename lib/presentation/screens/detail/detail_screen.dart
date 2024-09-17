import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/presentation/components/widget_divier.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String expenseId;
  const DetailScreen({super.key, required this.expenseId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late final detailViewmodel = ref.read(detailViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    detailViewmodel.loadExpenseById(widget.expenseId);
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(detailViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the default back button
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              DateFormat.EEEE().format(detailState.expense!.date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.teal, // White text for AppBar
              ),
            ),
            subtitle: Text(
              "${DateFormat.d().format(detailState.expense!.date)} ${DateFormat.MMMM().format(detailState.expense!.date)}",
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
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
        surfaceTintColor: Colors.transparent,
      ),
      body: detailState.expense != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WidgetTitle(title: 'Amount', clr: Colors.black),
                    Text(
                      "${detailState.expense!.amount}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 20),
                    ),
                    const WidgetDivier(),
                    const WidgetTitle(title: 'Category', clr: Colors.black),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/${categories[detailState.expense!.category!.index]["icon"]}",
                          width: 30,
                        ),
                        const Gap(16),
                        Text(
                          categories[detailState.expense!.category!.index]
                              ["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 18),
                        )
                      ],
                    ),
                    const WidgetDivier(),
                    const WidgetTitle(title: 'Receipts', clr: Colors.black),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('Empty Data'),
            ),
    );
  }
}
