import 'package:flutter/material.dart';

class WidgetToImage extends StatefulWidget {
  const WidgetToImage({Key? key, required this.builder}) : super(key: key);

  final Function(GlobalKey key) builder;

  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
