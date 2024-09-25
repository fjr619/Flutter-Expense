import 'package:flutter_riverpod/flutter_riverpod.dart';

class DirectoryNotifier extends StateNotifier<String?> {
  DirectoryNotifier() : super(null);

  void setDirectory(String dir) {
    state = dir;
  }
}

class CustomDirectoryNotifier extends DirectoryNotifier {
  CustomDirectoryNotifier(String initialDir) {
    setDirectory(initialDir);
  }
}

final directoryProvider = StateNotifierProvider<DirectoryNotifier, String?>((ref) {
  return DirectoryNotifier();
});
