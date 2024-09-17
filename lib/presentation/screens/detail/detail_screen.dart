import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/presentation/components/widget_divier.dart';
import 'package:flutter_expensetracker/presentation/components/widget_title.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
            appBar: AppBar(
              automaticallyImplyLeading:
                  false, // Remove the default back button
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    icon:
                        const Icon(Icons.cancel, size: 30, color: Colors.teal),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ),
              surfaceTintColor: Colors.transparent,
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
                              title: 'Receipts', clr: Colors.black),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: detailState.expense!.receipts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, mainAxisSpacing: 4.0),
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
                                      // If file exists, show the image
                                      return Image.file(
                                        file,
                                        width: 50,
                                      );
                                    } else {
                                      // If file does not exist, show a placeholder or a message
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[
                                            300], // Placeholder background
                                        child: const Icon(Icons
                                            .broken_image), // Placeholder icon
                                      );
                                    }
                                  } else {
                                    // While checking if the file exists, show a loading indicator
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors
                                          .grey[300], // Placeholder background
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                },
                              );
                            },
                          ),
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
