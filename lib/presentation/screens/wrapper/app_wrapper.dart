import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const AppWrapper({super.key, required this.navigationShell});

  void expenseViewModelReinit(WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(expenseViewmodelProvider.notifier);
      viewModel.reinitialize();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersistentTabView.router(
        onTabChanged: (value) {
          if (value == 1) {
            //reinit when change tab
            expenseViewModelReinit(ref);
          }
        },
        tabs: [
          PersistentRouterTabConfig(
            item: ItemConfig(
              activeColorSecondary: Colors.teal.withAlpha(20),
              activeForegroundColor: Colors.teal,
              icon: const Icon(Icons.home_rounded),
              title: "Home",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              activeColorSecondary: Colors.teal.withAlpha(20),
              activeForegroundColor: Colors.teal,
              icon: const Icon(Icons.add_rounded),
              title: "Expense",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              activeColorSecondary: Colors.teal.withAlpha(20),
              activeForegroundColor: Colors.teal,
              icon: const Icon(Icons.show_chart_rounded),
              title: "Stats",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              activeColorSecondary: Colors.teal.withAlpha(20),
              activeForegroundColor: Colors.teal,
              icon: const Icon(Icons.photo_album_rounded),
              title: "Gallery",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              activeColorSecondary: Colors.teal.withAlpha(20),
              activeForegroundColor: Colors.teal,
              icon: const Icon(Icons.add),
              title: "Settings",
            ),
          ),
        ],
        navBarBuilder: (config) => Style2BottomNavBar(navBarConfig: config),
        navigationShell: navigationShell);
  }
}
