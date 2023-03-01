import 'package:controle_pedidos/src/core/onboarding/store/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CustomPaginator extends StatelessWidget {
  const CustomPaginator({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = GetIt.I.get<OnboardingController>();

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
