import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expensetracker/domain/models/expense.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/domain/repositories/expense_repository.dart';
import 'package:flutter_expensetracker/domain/repositories/receipt_repository.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseViewmodel extends StateNotifier<ExpenseState> {
  final ReceiptRepository<Receipt> receiptRepository;
  final ExpenseRepository<Expense> expenseRepository;

  ExpenseViewmodel({
    required this.receiptRepository,
    required this.expenseRepository,
  }) : super(ExpenseState());

  void reinitialize() {
    state = ExpenseState.reset();
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

  void updateListTag(List<String>? newTags) {
    state = state.copyWith(tags: newTags);
  }

  void removeReceipt(int index) {
    // Create a new list by removing the item at the specified index
    final updatedReceipts = List<Map<String, dynamic>>.from(state.receiptDatas)
      ..removeAt(index);

    // Update the state with the new list
    state = state.copyWith(receiptDatas: updatedReceipts);
  }

  void uploadFile(
    FilePickerResult result,
    DateTime selectedDate,
    TextEditingController fileTextController,
    Function() onFinishUpload,
  ) async {
    File file = File(result.files.first.path!);
    String appPath = await getPath();

    String fileExtension = result.files.first.extension!;

    final filename =
        "${fileTextController.text}_${DateFormat("d_MM_yyy").format(selectedDate)}_${DateFormat("HH_mm_ss").format(DateTime.now())}.$fileExtension";

    fileTextController.clear();

    File newFile = await file.copy('$appPath/$filename');

    Uint8List imageBytes = await newFile.readAsBytes();

    log('path $appPath/$filename');

    final receipt = Receipt()..name = filename;

    state = state.copyWith(
        receiptDatas: List.from(state.receiptDatas)
          ..add({'receipt': receipt, 'image': imageBytes}));

    // log('newFile $appPath/$filename');

    onFinishUpload();
  }

  Future<void> createExpense({
    required String amount,
    required String subcat,
    List<String>? tags,
  }) async {
    updateAmount(double.parse(amount));
    updateSubcat(subcat);
    updateListTag(tags);

    final subcategory = SubCategory()..name = state.subCat;
    final formattedDate = state.selectedDate.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    List<Receipt> receipts = [];
    for (Map<String, dynamic> receiptDatas in state.receiptDatas) {
      final Receipt receipt = receiptDatas['receipt'];
      receipts.add(receipt);
      await receiptRepository.createObject(receipt);
    }

    Expense expense = Expense()
      ..amount = state.amount
      ..date = formattedDate
      ..category = CategoryEnum.values[state.selectedCategoryIndex]
      ..subCategory = subcategory
      ..description = state.tags
      ..paymentMethod = state.selectedPayment
      ..receipts.addAll(receipts);

    log('payment ${expense.paymentMethod} ${state.selectedPayment}}');

    await expenseRepository.createObject(expense);
  }
}
