import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expensetracker/domain/models/budget.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/income.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Isar isar;
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    isar = await Isar.open(
        [BudgetSchema, ExpenseSchema, ReceiptSchema, IncomeSchema],
        directory: dir.path, name: 'expenseInstance');
  }
  isar = Isar.getInstance('expenseInstance')!;

  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expense tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        textTheme: Theme.of(context).textTheme.apply(
            fontFamily: GoogleFonts.poppins().fontFamily,
            bodyColor: Colors.teal),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.teal, // Cursor color
          selectionColor: Colors.teal[100], // Text selection highlight color
          selectionHandleColor: Colors.teal, // Handles color
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.teal, // Header background color (year/month picker)
          onPrimary: Colors.white, // Header text color
          surface: Colors.white, // Background color of the dialog
          onSurface: Colors.teal, // Color of the days in the calendar grid
        ),
        dialogBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
