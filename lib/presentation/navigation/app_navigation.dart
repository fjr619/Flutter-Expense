import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/gallery/gallery_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/home/home_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/settings/settings_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/stats/stats_screen.dart';
import 'package:flutter_expensetracker/presentation/screens/wrapper/app_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static String initial = "/home";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorExpense =
      GlobalKey<NavigatorState>(debugLabel: 'shellExpense');
  static final _shellNavigatorStats =
      GlobalKey<NavigatorState>(debugLabel: 'shellStats');
  static final _shellNavigatorGallery =
      GlobalKey<NavigatorState>(debugLabel: 'shellGallery');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
      initialLocation: initial,
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainWrapper(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNavigatorHome,
              routes: [
                GoRoute(
                  path: "/home",
                  name: "home",
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorExpense,
              routes: [
                GoRoute(
                    path: "/expense",
                    name: "expense",
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: ExpenseScreen(
                          key: ProviderScope.containerOf(context)
                              .read(expenseScreenKeyProvider),
                        ),
                        restorationId:
                            'expense_route', // Enable state restoration
                      );
                    }),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorStats,
              routes: [
                GoRoute(
                  path: "/stats",
                  name: "stats",
                  builder: (context, state) => const StatsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorGallery,
              routes: [
                GoRoute(
                  path: "/gallery",
                  name: "gallery",
                  builder: (context, state) => const GalleryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorSettings,
              routes: [
                GoRoute(
                  path: "/settings",
                  name: "settings",
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ]);
}
