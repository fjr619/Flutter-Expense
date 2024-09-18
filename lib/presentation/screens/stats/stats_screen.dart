import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/expense_log_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/general/general_stats_screen.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int stats = 0;
  Widget? expenseLogScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Stats',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        body: Column(
          children: [
            ToggleSwitch(
              activeBgColor: const [Colors.teal],
              animate: true,
              animationDuration: 200,
              inactiveBgColor: Colors.grey.shade300,
              initialLabelIndex: stats,
              cornerRadius: 30,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              labels: const ['General', 'Expense log'],
              totalSwitches: 2,
              onToggle: (index) {
                setState(() {
                  stats = index!;

                  // Lazy initialization for ExpenseLogScreen when needed
                  if (stats == 1 && expenseLogScreen == null) {
                    expenseLogScreen = const ExpenseLogScreen();
                  }
                });
              },
            ),
            Expanded(
              child: IndexedStack(
                index: stats,
                children: [
                  const GeneralStatsScreen(),
                  expenseLogScreen ?? Container(),
                ],
              ),
            ),
          ],
        ));
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         title: const Text(
//           'Stats',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
//         ),
//       ),
//       body: PageStorage(
//         bucket: bucket,
//         child: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return [
//               SliverAppBar(
//                 surfaceTintColor: Colors.transparent,
//                 backgroundColor: Colors.white,
//                 pinned: true, // This keeps the ToggleSwitch pinned at the top
//                 automaticallyImplyLeading: false,
//                 flexibleSpace: Center(
//                   child: ToggleSwitch(
//                     activeBgColor: const [Colors.teal],
//                     animate: true,
//                     animationDuration: 200,
//                     inactiveBgColor: Colors.grey.shade300,
//                     initialLabelIndex: stats,
//                     cornerRadius: 30,
//                     minWidth: MediaQuery.of(context).size.width * 0.4,
//                     labels: const ['General', 'Expense log'],
//                     totalSwitches: 2,
//                     onToggle: (index) {
//                       setState(() {
//                         stats = index!;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: (stats == 0)
//               ? const GeneralStatsScreen()
//               : const ExpenseLogScreen(),
//         ),
//       ),
//     );
//   }
