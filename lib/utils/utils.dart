import 'package:flutter/material.dart';

class Utils {
  static Widget buildBackground() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [
              -0.098,
              0.015,
              0.12,
              0.90,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFF19293e),
              Color(0xFF030f12),
              Color(0xFF10231f),
              Color(0xFF31648c),
            ],
          )),
    );
  }
}