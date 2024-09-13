import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_screen.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainWrapper({super.key, required this.navigationShell});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goBranch(int index) async {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    if (index == 1) {
      final ref = ProviderScope.containerOf(context);
      // ref.read(expenseViewmodelProvider.notifier).reinitialize();

      final settingScreenKey = ref.read(expenseScreenKeyProvider);
      settingScreenKey.currentState?.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goBranch(selectedIndex);
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_rounded),
            title: const Text("Expense"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.show_chart_rounded),
            title: const Text("Stats"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.photo_album_rounded),
            title: const Text("Gallery"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.teal,
            unselectedColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
