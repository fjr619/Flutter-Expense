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
    Function() onFinishUpload,
  ) async {
    File file = File(result.files.single.path!);

    Uint8List imageBytes = result.files.first.bytes ?? await file.readAsBytes();

    String? fileExtension = result.files.first.extension;

    final filename =
        "${fileTextController.text}_${DateFormat("d_MM_yyy").format(selectedDate)}.$fileExtension";

    final receipt = Receipt()..name = filename;

    state = state.copyWith(
        receiptDatas: List.from(state.receiptDatas)
          ..add({'receipt': receipt, 'image': imageBytes}));

    fileTextController.clear();

    onFinishUpload();
  }
}
