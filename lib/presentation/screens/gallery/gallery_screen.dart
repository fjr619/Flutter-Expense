import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_full_image.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  late String _path;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final galleryVM = ref.read(galleryViewModelProvider.notifier);
      galleryVM.getAllReceipt();
      _path = await getPath().then((value) => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryViewModelProvider);
    log("== aaaa");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Gallery',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          actions: [
            if (galleryState.receipts.isNotEmpty) ...{
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 30,
                  ))
            }
          ],
        ),
        body: galleryState.receipts.isEmpty
            ? const WidgetEmpty(
                subtitle: 'No Receipts to display',
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: galleryState.receipts.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    Receipt receipt = galleryState.receipts[index];
                    return Column(
                      // Adjusts to the content size
                      children: [
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: InstaImageViewer(
                                child: Image.file(
                                  File("$_path/${receipt.name}"),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text("aaaaa")
                      ],
                    );
                  },
                ),
              ));
  }
}
