import 'package:flutter/material.dart';

class RepaintBoundaryWidgetKey extends StatefulWidget {
  const RepaintBoundaryWidgetKey({Key? key, required this.builder}) : super(key: key);

  final Function(GlobalKey key) builder;

  @override
  _RepaintBoundaryWidgetKeyState createState() => _RepaintBoundaryWidgetKeyState();
}

class _RepaintBoundaryWidgetKeyState extends State<RepaintBoundaryWidgetKey> {

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
