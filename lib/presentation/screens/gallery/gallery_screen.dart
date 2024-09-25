import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/domain/models/receipt.dart';
import 'package:flutter_expensetracker/presentation/components/widget_empty.dart';
import 'package:flutter_expensetracker/presentation/components/widget_full_image.dart';
import 'package:flutter_expensetracker/presentation/components/widget_image_item.dart';
import 'package:flutter_expensetracker/provider/directory_provider.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  late final path = ref.read(directoryProvider);

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryViewModelProvider);
    log("== build gallery");
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
                    File file = File('$path/${receipt.name}');
                    return Column(
                      children: [
                        Flexible(
                          child: WidgetImageItem(file: file),
                        ),
                        const Text("aaaaa")
                      ],
                    );
                  },
                ),
              ));
  }
}
