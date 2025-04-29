import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashConfig {
  static const String splashImage = 'assets/images/splash.png';
  static const String logoImage = 'assets/images/logo.png';
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static const double logoSize = 150.0;
  static const double textSize = 24.0;
  static const Duration animationDuration = Duration(seconds: 2);

  static TextStyle get textStyle {
    return GoogleFonts.notoSans(
      fontSize: textSize,
      color: textColor,
      fontWeight: FontWeight.bold,
    );
  }
}
