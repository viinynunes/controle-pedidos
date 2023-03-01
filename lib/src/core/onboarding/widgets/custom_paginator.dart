import 'package:flutter/material.dart';

class CustomPaginator extends StatelessWidget {
  const CustomPaginator({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) {
          final color =
              index == currentPage ? colorScheme.primary : Colors.grey;
          return Container(
            margin: const EdgeInsets.all(12),
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
        },
      ),
    );
  }
}
