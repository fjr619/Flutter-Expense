import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/navigation/app_navigation.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:go_router/go_router.dart';

class FilterByScreen extends StatelessWidget {
  const FilterByScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text(
                "Filter By",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.teal, // White text for AppBar
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.cancel, size: 30, color: Colors.teal),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: buildWidget(context),
          ),
        ),
      ),
    );
  }

  List<Widget> buildWidget(BuildContext context) {
    List<Widget> options = [];

    for (int i = 0; i < filterOptions.length; i++) {
      options.add(Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            gotoFilter(context, i);
          },
          child: ListTile(
            title: Text(filterOptions[i]),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.teal,
            ),
          ),
        ),
      ));
    }
    return options;
  }
}
