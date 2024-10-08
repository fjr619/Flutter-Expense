import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_stats.dart';
import 'package:flutter_expensetracker/presentation/components/widget_header.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralStatsScreen extends ConsumerStatefulWidget {
  const GeneralStatsScreen({super.key});

  @override
  ConsumerState<GeneralStatsScreen> createState() => _GeneralStatsScreenState();
}

class _GeneralStatsScreenState extends ConsumerState<GeneralStatsScreen> {
  late final generalViewModel = ref.read(generalViewModelProvider.notifier);
  late final homeViewmodel = ref.read(homeViewmodelProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewmodelProvider);
    final generalState = ref.watch(generalViewModelProvider);

    return SingleChildScrollView(
      key: const PageStorageKey<String>('general_log'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            WidgetHeader(
              percent: homeState.percent,
              totalValue: homeState.totalValue,
              budgetValue: homeState.budgetValue,
              canEdit: false,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WidgetCategoryStats(
                budgetValue: generalState.budgetValue,
                categoriesSum: generalState.categorySum,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
