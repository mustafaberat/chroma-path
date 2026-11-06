import 'package:flutter/material.dart';

/// Blush brunch table. Frosting hues stay in the same seven families.
abstract final class AppColors {
  static const Color background = Color(0xFFF6E4DA);
  static const Color blush = Color(0xFFF3D5C8);
  static const Color surface = Color(0xFFFFF6EE);
  static const Color plate = Color(0xFFFFF8F3);
  static const Color ink = Color(0xFF4A3428);
  static const Color muted = Color(0xFF8C6B58);
  static const Color faint = Color(0xFFC4A898);
  static const Color line = Color(0xFFE8D0C4);
  static const Color board = Color(0xFFE8C98A);
  static const Color waffle = Color(0xFFE8C98A);
  static const Color waffleEdge = Color(0xFFD4A85A);
  static const Color wafflePocket = Color(0xFFC4924A);
  static const Color onAccent = Color(0xFFFFF8F2);
  static const Color scrim = Color(0xD9F6E4DA);
  static const Color transparent = Color(0x00000000);

  static const Color berry = Color(0xFFD4536A);
  static const Color gold = Color(0xFFE0A84A);
  static const Color blue = Color(0xFF5AA6DE);
  static const Color green = Color(0xFF6ED4B8);
  static const Color yellow = Color(0xFFF0C14A);
  static const Color danger = Color(0xFFD4536A);
}

abstract final class Palette {
  static const List<Color> colors = [
    Color(0xFFE86B86),
    Color(0xFF5AA6DE),
    Color(0xFF6ED4B8),
    Color(0xFFF6E36A),
    Color(0xFFF09455),
    Color(0xFFE86AAD),
    Color(0xFFA678D8),
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
