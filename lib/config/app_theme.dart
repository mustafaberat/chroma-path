import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static ThemeData get current {
    final scheme = ColorScheme.light(
      primary: AppColors.berry,
      onPrimary: AppColors.onAccent,
      secondary: AppColors.gold,
      onSecondary: AppColors.ink,
      error: AppColors.danger,
      onError: AppColors.onAccent,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 40,
          height: 0.95,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -1.2,
        ),
        titleLarge: TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w700, color: AppColors.ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.2),
        bodyMedium: TextStyle(fontSize: 15, height: 1.35, fontWeight: FontWeight.w500, color: AppColors.muted),
        bodySmall: TextStyle(fontSize: 13, height: 1.3, fontWeight: FontWeight.w500, color: AppColors.faint),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onAccent),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.berry,
          foregroundColor: AppColors.onAccent,
          minimumSize: const Size(64, AppDimens.buttonHeight),
          shape: shape,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size(64, AppDimens.buttonHeight),
          side: const BorderSide(color: AppColors.line),
          shape: shape,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ink,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.ink),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.berry,
        disabledColor: AppColors.blush,
        labelStyle: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
        secondaryLabelStyle: const TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w700),
        checkmarkColor: AppColors.onAccent,
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: shape,
        titleTextStyle: const TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w700),
        contentTextStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 15,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onAccent;
          return AppColors.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.berry;
          return AppColors.line;
        }),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w600),
      ),
    );
  }
}
