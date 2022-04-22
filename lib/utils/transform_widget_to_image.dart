import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TransformWidgetToImage {
  static getWidget(GlobalKey key, String fileName) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    await saveFileAndLaunchFile(pngBytes!, fileName);
  }

  static Future<void> saveFileAndLaunchFile(
      Uint8List bytes, String fileName) async {
    if (!kIsWeb) {
      final path = (await getExternalStorageDirectory())?.path;
      final file = File('$path/$fileName.png');
      await file.writeAsBytes(bytes);
      Share.shareFiles([(file.path)]);
    } else {
      await FileSaver.instance.saveFile('$fileName.png', bytes, 'png');
    }
  }
}
