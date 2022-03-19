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
              Color(0xFF281c66),
              Color(0xFF1b0247),
              Color(0xFF361c66),
              Color(0xFF281c66),
            ],
          )),
    );
  }
}