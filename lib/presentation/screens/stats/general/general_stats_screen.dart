import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_stats.dart';
import 'package:flutter_expensetracker/presentation/components/widget_header.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GeneralStatsScreen extends ConsumerStatefulWidget {
  const GeneralStatsScreen({super.key});

  @override
  ConsumerState<GeneralStatsScreen> createState() => _GeneralStatsScreenState();
}

class _GeneralStatsScreenState extends ConsumerState<GeneralStatsScreen> {
  late final generalViewModel = ref.read(generalViewModelProvider.notifier);
  late final homeViewmodel = ref.read(homeViewmodelProvider.notifier);
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewmodelProvider);
    final generalState = ref.watch(generalViewModelProvider);

    return _isLoading
        ? const Center(
            child:
                CircularProgressIndicator(), // Show loading indicator when _isLoading is true
          )
        : SingleChildScrollView(
            key: const PageStorageKey<String>('expense_log'),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  WidgetHeader(
                    percent: homeState.percent,
                    totalValue: homeState.totalValue,
                    budgetValue: homeState.budgetValue,
                    canEdit: false,
                  ),
                  WidgetCategoryStats(
                    budgetValue: generalState.budgetValue,
                    categoriesSum: generalState.categorySum,
                  ),
                ],
              ),
            ),
          );
  }
}
