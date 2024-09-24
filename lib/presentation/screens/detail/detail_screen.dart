import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_divier.dart';
import 'package:flutter_expensetracker/presentation/components/widget_image_item.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String expenseId;
  const DetailScreen({super.key, required this.expenseId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late final detailViewmodel = ref.read(detailViewModelProvider.notifier);
  bool _loading = true;
  late String _path;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await detailViewmodel.loadExpenseById(
        widget.expenseId,
        () {
          setState(() {
            _loading = false;
          });
        },
      );

      _path = await getPath().then((value) => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(detailViewModelProvider);

    return _loading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(65.0), // Set the height of the AppBar
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SafeArea(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        DateFormat.EEEE().format(detailState.expense!.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal, // White text for AppBar
                        ),
                      ),
                      subtitle: Text(
                        "${DateFormat.d().format(detailState.expense!.date)} ${DateFormat.MMMM().format(detailState.expense!.date)}",
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel,
                            size: 30, color: Colors.teal),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ),
                ),
                surfaceTintColor: Colors.transparent,
              ),
            ),
            body: detailState.expense != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WidgetTitle(title: 'Amount', clr: Colors.black),
                          Text(
                            "${detailState.expense!.amount}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 20),
                          ),
                          const WidgetDivier(),
                          const WidgetTitle(
                              title: 'Category', clr: Colors.black),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/${categories[detailState.expense!.category!.index]["icon"]}",
                                width: 30,
                              ),
                              const Gap(16),
                              Text(
                                categories[detailState.expense!.category!.index]
                                    ["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                    fontSize: 18),
                              )
                            ],
                          ),
                          const WidgetDivier(),
                          const WidgetTitle(
                              title: 'Sub Category', clr: Colors.black),
                          Text(detailState.expense!.subCategory?.name
                                  .toString() ??
                              ''),
                          const WidgetDivier(),
                          const WidgetTitle(
                              title: 'Receipts', clr: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: detailState.expense!.receipts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4),
                              itemBuilder: (context, index) {
                                // Get the file path
                                String filePath =
                                    '$_path/${detailState.expense!.receipts.elementAt(index).name}';
                                File file = File(filePath);

                                return FutureBuilder<bool>(
                                  future: file.exists(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData && snapshot.data!) {
                                        return WidgetImageItem(
                                          file: file,
                                          onclickItem: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  insetPadding:
                                                      const EdgeInsets.all(10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      // Constraints give us access to the dialog's width and height
                                                      double dialogWidth =
                                                          constraints.maxWidth;

                                                      return Stack(
                                                        children: [
                                                          // PhotoView displaying the image
                                                          PhotoView(
                                                            imageProvider:
                                                                FileImage(file),
                                                          ),
                                                          // Positioned Close Button relative to the width of the dialog
                                                          Positioned(
                                                            top: 10,
                                                            right: dialogWidth *
                                                                0.02, // Calculate position based on the dialog width
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .cancel_rounded, // X icon
                                                                size: 32,
                                                                color: Colors
                                                                    .teal, // White icon color
                                                              ),
                                                              onPressed: () {
                                                                context
                                                                    .pop(); // Close the dialog or perform the action
                                                              },
                                                              splashColor: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.3), // Optional ripple color
                                                              splashRadius:
                                                                  24, // Ripple size
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image),
                                        );
                                      }
                                    } else {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                        child:
                                            const CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const WidgetDivier(),
                          const WidgetTitle(
                              title: 'Payment Method', clr: Colors.black),
                          Text(detailState.expense!.paymentMethod.toString()),
                          const WidgetDivier(),
                          const WidgetTitle(title: 'Tags', clr: Colors.black),
                          const Gap(5),
                          detailState.expense!.description != null
                              ? Wrap(
                                  runSpacing: 5,
                                  children:
                                      detailState.expense!.description!.map(
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
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Text(
                                          '#$tag',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('Empty Data'),
                  ),
          );
  }
}
