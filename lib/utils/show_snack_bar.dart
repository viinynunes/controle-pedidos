import 'package:flutter/material.dart';

class ShowSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const LinearProgressIndicator(),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 10,
      ),
    );
  }
}
