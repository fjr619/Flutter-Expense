import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expensetracker/presentation/components/widget_category_item.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_state.dart';
import 'package:flutter_expensetracker/presentation/screens/expense/expense_viewmodel.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:textfield_tags/textfield_tags.dart';

final expenseScreenKeyProvider =
    Provider((ref) => GlobalKey<_ExpenseScreenState>());

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _subCatTextController = TextEditingController();
  final TextEditingController _fileTextController = TextEditingController();
  final StringTagController _descTextController = StringTagController();
  late final ExpenseViewmodel expenseViewmodel =
      ref.read(expenseViewmodelProvider.notifier);

  bool showLoadingReceipt = false;
  double _distanceToField = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _amountTextController.dispose();
    _subCatTextController.dispose();
    _scrollController.dispose();
    _descTextController.dispose();
    super.dispose();
  }

  void clearForm() {
    _formKey.currentState?.reset();
    expenseViewmodel.reinitialize();

    _amountTextController.clear();
    _subCatTextController.clear();
    _fileTextController.clear();
    _descTextController.clearTags();
    _descTextController.getFocusNode?.unfocus();
    FocusScope.of(context).unfocus();

    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Easing.linear);
    }
  }

  String? validateInputAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an amount";
    }
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  String? validateInputSubCat(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a sub category";
    }
    return null;
  }

  Widget _textFormAmount(ExpenseState expenseState) {
    return TextFormField(
      autovalidateMode: expenseState.doValidationAmount
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      controller: _amountTextController,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^\d+\.?\d*')), // Allow numbers and one decimal point
      ],
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        hintStyle: TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
        hintText: "Enter amount",
        prefix: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            "Rp",
            style: TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      validator: validateInputAmount,
      onChanged: (value) {
        final state = ref.read(expenseViewmodelProvider);
        if (!state.doValidationAmount) {
          ref
              .read(expenseViewmodelProvider.notifier)
              .updatedoValidationAmount(true);
        }
      },
    );
  }

  Widget _datePicker(ExpenseState expenseState) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(expenseState.selectedDate),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          IconButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: expenseState.selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                expenseViewmodel.updateSelectedDate(pickedDate);
              }
            },
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categorySelection(ExpenseState expenseState) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 4),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return WidgetCategoryItem(
          index: index,
          selectedCategoryIndex: expenseState.selectedCategoryIndex,
          onSelected: () {
            FocusScope.of(context).unfocus();
            expenseViewmodel.updateSelectedCategoryIndex(index);
          },
        );
      },
    );
  }

  Widget _textFormSubCat(ExpenseState expenseState) {
    return TextFormField(
      controller: _subCatTextController,
      autovalidateMode: expenseState.doValidationSubCat
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.end,
      decoration: const InputDecoration(
        hintStyle: TextStyle(fontSize: 14, color: Colors.black),
        hintText: "Enter sub category",
      ),
      validator: validateInputSubCat,
      onChanged: (value) {
        final state = ref.read(expenseViewmodelProvider);
        if (!state.doValidationSubCat) {
          ref
              .read(expenseViewmodelProvider.notifier)
              .updatedoValidationSubCat(true);
        }
      },
    );
  }

  Widget _paymentSelection(ExpenseState expenseState) {
    return DropdownButton(
      isExpanded: true,
      value: expenseState.selectedPayment,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: paymentMethodsDummy.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (value) {
        FocusScope.of(context).unfocus();
        expenseViewmodel.updateSelectedPayment(value);
      },
    );
  }

  Widget _receiptImage(BuildContext context, ExpenseState expenseState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WidgetTitle(title: "Add receipt", clr: Colors.black),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: IconButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      withReadStream: true,
                    );
                    if (result != null) {
                      setState(() {
                        showLoadingReceipt = true;
                      });
                      if (context.mounted) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Enter file name',
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 14),
                              ),
                              content: TextField(
                                controller: _fileTextController,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _fileTextController.clear();
                                      showLoadingReceipt = false;
                                      context.pop();
                                    });
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.pop();
                                    expenseViewmodel.uploadFile(
                                      result,
                                      expenseState.selectedDate,
                                      _fileTextController,
                                      () {
                                        setState(() {
                                          showLoadingReceipt = false;
                                        });
                                      },
                                    );
                                  },
                                  style: const ButtonStyle(
                                      elevation: WidgetStatePropertyAll(0),
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.teal),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add)),
            )
          ],
        ),
        if (showLoadingReceipt) ...{
          Visibility(
            visible: showLoadingReceipt,
            child: const SizedBox(
              width: double.infinity,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        } else if (expenseState.receiptDatas.isEmpty) ...{
          const SizedBox(
            width: double.infinity,
            height: 100,
            child: WidgetEmpty(
              subtitle: 'Empty Receipt',
            ),
          ),
        } else ...{
          GridView.builder(
            shrinkWrap: true,
            itemCount: expenseState.receiptDatas.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              final dataMap = expenseState.receiptDatas[index];
              final image = dataMap['image'];
              return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.teal.shade100,
                  onTap: () {},
                  child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Ink.image(
                        image: MemoryImage(image),
                      )));
            },
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 4.0),
          ),
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textFormAmount(expenseState),
                _datePicker(expenseState),
                const WidgetTitle(title: 'Select category', clr: Colors.black),
                const Gap(10),
                _categorySelection(expenseState),
                const Gap(10),
                _textFormSubCat(expenseState),
                const Gap(10),
                const WidgetTitle(
                    title: "Select payment method", clr: Colors.black),
                _paymentSelection(expenseState),
                const Gap(10),
                _receiptImage(context, expenseState),
                const Gap(10),
                const WidgetTitle(title: 'Notes', clr: Colors.black),
                TextFieldTags(
                  textfieldTagsController: _descTextController,
                  initialTags: const <String>[],
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter tag';
                    } else if (_descTextController.getTags!.contains(value)) {
                      return 'You\'ve already entered that';
                    }
                    return null;
                  },
                  inputFieldBuilder: (context, inputFieldValues) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: inputFieldValues.textEditingController,
                        focusNode: inputFieldValues.focusNode,
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                        decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.0,
                              ),
                            ),
                            helperText: 'Enter tags',
                            helperStyle: const TextStyle(
                              color: Colors.teal,
                            ),
                            hintText: inputFieldValues.tags.isNotEmpty
                                ? ''
                                : "Enter tag",
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: _distanceToField * 0.70),
                            prefixIcon: inputFieldValues.tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller:
                                        inputFieldValues.tagScrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: inputFieldValues.tags.map(
                                        (tag) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: Colors.teal,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    '#$tag',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onTap: () {
                                                    //print("$tag selected");
                                                  },
                                                ),
                                                const SizedBox(width: 4.0),
                                                InkWell(
                                                  onTap: () {
                                                    inputFieldValues
                                                        .onTagRemoved(tag);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  )
                                : null),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.8, 50)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await expenseViewmodel.createExpense(
                                amount: _amountTextController.text,
                                subcat: _subCatTextController.text,
                                tags: _descTextController.getTags);

                            if (context.mounted) {
                              StatusAlert.show(context,
                                  duration: const Duration(seconds: 2),
                                  title: 'Expense Tracker',
                                  subtitle: 'Expense added!',
                                  configuration:
                                      const IconConfiguration(icon: Icons.done),
                                  maxWidth: 260);
                            }
                            clearForm();
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
