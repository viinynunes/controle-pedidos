import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.circular(
      {super.key,
      required this.height,
      this.width = double.infinity,
      this.shapeBorder = const CircleBorder()});

  const ShimmerWidget.rectangular(
      {super.key, required this.height, this.width = double.infinity})
      : shapeBorder = const RoundedRectangleBorder();

  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    final lightTheme = Theme.of(context).brightness == Brightness.light;

    return Shimmer.fromColors(
      baseColor: lightTheme ? Colors.grey[200]! : Colors.grey[900]!,
      highlightColor: lightTheme ? Colors.grey[300]! : Colors.grey[800]!,
      period: const Duration(milliseconds: 500),
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(color: Colors.grey, shape: shapeBorder),
      ),
    );
  }
}
