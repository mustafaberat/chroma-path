import 'package:flutter/material.dart';

/// Grayscale interface. Colored pieces use the shared hue ring only.
abstract final class AppColors {
  static const Color background = Color(0xFFF3F3F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color board = Color(0xFFE4E4E4);
  static const Color ink = Color(0xFF2A2A2A);
  static const Color muted = Color(0xFF7A7A7A);
  static const Color faint = Color(0xFFB0B0B0);
  static const Color line = Color(0xFFD5D5D5);
  static const Color onAccent = Color(0xFFEBEBEB);
  static const Color scrim = Color(0xCCF3F3F3);
  static const Color transparent = Color(0x00000000);

  static const Color blue = Color(0xFF54A0EB);
  static const Color green = Color(0xFF54EBAC);
  static const Color yellow = Color(0xFFEBE654);
  static const Color danger = Color(0xFFEB545E);
}

abstract final class Palette {
  static const List<Color> colors = [
    Color(0xFFEB545E),
    Color(0xFF54A0EB),
    Color(0xFF54EBAC),
    Color(0xFFEBE654),
    Color(0xFFEB8154),
    Color(0xFFEB54AC),
    Color(0xFF9354EB),
  ];

  static Color of(int index) => colors[index % colors.length];
}

abstract final class AppDimens {
  static const double page = 24;
  static const double gap = 12;
  static const double gapL = 20;
  static const double radius = 18;
  static const double maxContent = 520;
  static const double wide = 700;
  static const double buttonHeight = 56;
}

abstract final class AppMotion {
  static const Duration pulse = Duration(milliseconds: 1400);
  static const Duration win = Duration(milliseconds: 520);
  static const Duration startup = Duration(seconds: 8);
}
