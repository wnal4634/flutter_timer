import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4E5AE8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFFF4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = const Color(0xFF424242);

class Themes {
  //테마설정
  static final light = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryClr,
      background: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: darkGreyClr,
      brightness: Brightness.dark,
      background: darkGreyClr,
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[800],
    ),
  );
}

TextStyle get lato {
  return GoogleFonts.lato(
    textStyle: const TextStyle(),
  );
}

TextStyle get latoBold {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
    ),
  );
}
