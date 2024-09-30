import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
      body: Column(
        children: [
          // ListTile(
          //   onTap: () {},
          //   leading: Container(
          //       decoration: const BoxDecoration(
          //           shape: BoxShape.circle, color: Colors.teal),
          //       child: const Padding(
          //         padding: EdgeInsets.all(15.0),
          //         child: Text(
          //           "\$",
          //           style: TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.bold),
          //         ),
          //       )),
          //   title: const Text(
          //     "US Dollars",
          //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          //   ),
          //   trailing: const Icon(Icons.keyboard_arrow_right),
          // ),
          Consumer(
            builder: (context, ref, child) {
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 50)),
                    onPressed: () async {
                      await ref
                          .read(expenseListViewmodelProvider.notifier)
                          .deleteAll();
                    },
                    child: const Text(
                      "Clear Data",
                      style: TextStyle(color: Colors.white),
                    )),
              );
            },
          )
        ],
      ),
    );
  }
}
