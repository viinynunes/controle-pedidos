import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const textTheme = TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.w600),
  titleMedium: TextStyle(fontWeight: FontWeight.bold),
  bodyMedium: TextStyle(fontWeight: FontWeight.bold),
  labelSmall: TextStyle(color: Colors.green),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontWeight: FontWeight.bold, )
    ));

final fontFamily = GoogleFonts
    .montserrat()
    .fontFamily;
