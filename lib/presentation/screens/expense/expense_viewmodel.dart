import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseViewmodel extends StateNotifier<ExpenseState> {
  ExpenseViewmodel() : super(ExpenseState());

  void reinitialize() {
    state = state.copyWith(
        amount: 0,
        selectedDate: DateTime.now(),
        selectedCategoryIndex: 0,
        doValidationAmount: false,
        selectedPayment: null,
        subCat: null,
        doValidationSubCat: false,
        receiptDatas: []);
  }

  void updateSelectedDate(DateTime newDate) {
    state = state.copyWith(selectedDate: newDate);
  }

  void updateSelectedCategoryIndex(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }

  void updateAmount(double newAmount) {
    state = state.copyWith(amount: newAmount);
  }

  void updatedoValidationAmount(bool value) {
    state = state.copyWith(doValidationAmount: value);
  }

  void updateSelectedPayment(String? value) {
    log('payment $value');
    state = state.copyWith(selectedPayment: value);
  }

  void updateSubcat(String? value) {
    state = state.copyWith(subCat: value);
  }

  void updatedoValidationSubCat(bool value) {
    state = state.copyWith(doValidationSubCat: value);
  }

  void uploadFile(
    FilePickerResult result,
    DateTime selectedDate,
    TextEditingController fileTextController,
  ) async {
    File file = File(result.files.single.path!);
    String appPath = await getPath();

    List<String> nameAndExtension = result.files.single.name.split(".");
    final reversed = nameAndExtension.reversed.toList();

    final filename =
        "${fileTextController.text}_${DateFormat("d_MM_yyy").format(selectedDate)}.${reversed[0]}";

    fileTextController.clear();

    log('filename $filename');

    File newFile = await file.copy('$appPath/$filename');
    Uint8List imageBytes = await newFile.readAsBytes();
    // files.add(imageBytes);

    final receipt = Receipt()..name = filename;
    // receipts.add(receipt);

    state = state.copyWith(
        receiptDatas: List.from(state.receiptDatas)
          ..add({'receipt': receipt, 'image': imageBytes}));

    // show = false;
  }
}
