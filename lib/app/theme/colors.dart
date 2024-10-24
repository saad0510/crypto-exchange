import 'package:flutter/material.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const highlight = Color(0xFFE1F2FA);
  static const primary = Color(0xFFFE2323);
  static const scaffoldDark = BlackColor.dark;
  static const scaffoldLight = white;

  static final colors = ColorScheme.fromSeed(seedColor: primary) //
      .copyWith(error: ErrorColor.normal);
}

class BlackColor {
  static const dark = Color(0xFF1D1D1F);
  static const medium = Color(0xFF313133);
  static const normal = Color(0xFF3D3C3F);
  static const light = Color(0xFF8C8A93);
}

class ErrorColor {
  static const normal = Color(0xFFD71A21);
  static const light = Color(0xFFFF6363);
  static const dark = Color(0xFFA9001D);
}
