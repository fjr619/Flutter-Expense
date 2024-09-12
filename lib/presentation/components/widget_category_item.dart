import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/util/util.dart';

class WidgetCategoryItem extends StatelessWidget {
  const WidgetCategoryItem({
    super.key,
    required this.index,
    required this.onSelected,
    required this.selectedCategoryIndex,
  });

  final int index;
  final Function() onSelected;
  final int selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for the card
      ),
      color: (index == selectedCategoryIndex)
          ? Colors.teal.shade100
          : Colors.white,
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.teal.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/${categories[index]["icon"]}",
              width: 40,
            ),
            Text(
              categories[index]["name"],
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: (index == selectedCategoryIndex)
                      ? Colors.teal
                      : const Color.fromRGBO(155, 162, 161, 1)),
            )
          ],
        ),
      ),
    );
  }
}
