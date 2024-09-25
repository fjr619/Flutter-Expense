import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavVisibilityNotifier extends StateNotifier<bool> {
  BottomNavVisibilityNotifier() : super(true);

  // Method to show the bottom navigation bar
  void show() => state = true;

  // Method to hide the bottom navigation bar
  void hide() => state = false;

  // Toggle the visibility
  void toggle() => state = !state;
}

// Riverpod provider for the BottomNavVisibilityNotifier
final bottomNavVisibilityProvider =
    StateNotifierProvider<BottomNavVisibilityNotifier, bool>(
  (ref) => BottomNavVisibilityNotifier(),
);
