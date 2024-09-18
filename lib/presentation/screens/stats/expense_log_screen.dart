import 'dart:developer';

import 'package:flutter/material.dart';

class ExpenseLogScreen extends StatefulWidget {
  const ExpenseLogScreen({super.key});

  @override
  State<ExpenseLogScreen> createState() => _ExpenseLogScreenState();
}

class _ExpenseLogScreenState extends State<ExpenseLogScreen> {
  @override
  void initState() {
    super.initState();
    log('init _ExpenseLogScreenState');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
