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
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[300]!,
      period: const Duration(milliseconds: 400),
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(color: Colors.grey, shape: shapeBorder),
      ),
    );
  }
}
