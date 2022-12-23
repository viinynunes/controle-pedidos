import 'package:flutter/material.dart';

import 'shimer_widget.dart';

class ShimmerListBuilder extends StatelessWidget {
  const ShimmerListBuilder(
      {Key? key,
      required this.height,
      required this.width,
      required this.itemCount})
      : super(key: key);

  final double height;
  final double width;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: ShimmerWidget.circular(
                shapeBorder: border,
                height: height,
                width: width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
