import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TransformWidgetToImage {
  static getWidget(GlobalKey key, String fileName) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    await saveFileAndLaunchFile(pngBytes!, fileName);
  }

  static Future<void> saveFileAndLaunchFile(
      Uint8List bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName.png');
    await file.writeAsBytes(bytes);
    Share.shareFiles([(file.path)]);
  }
}
