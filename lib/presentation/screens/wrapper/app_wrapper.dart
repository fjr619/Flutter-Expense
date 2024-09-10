import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView.router(
        tabs: [
          PersistentRouterTabConfig(
            item: ItemConfig(
              icon: const Icon(Icons.home_rounded),
              title: "Home",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              icon: const Icon(Icons.add_rounded),
              title: "Expense",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              icon: const Icon(Icons.show_chart_rounded),
              title: "Stats",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              icon: const Icon(Icons.photo_album_rounded),
              title: "Gallery",
            ),
          ),
          PersistentRouterTabConfig(
            item: ItemConfig(
              icon: const Icon(Icons.add),
              title: "Settings",
            ),
          ),
        ],
        navBarBuilder: (config) => Style2BottomNavBar(navBarConfig: config),
        navigationShell: navigationShell);
  }
}
