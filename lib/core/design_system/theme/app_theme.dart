import 'package:flutter/material.dart';

import 'exchange_colors.dart';

abstract final class AppTheme {
  static final ThemeData light = _theme(Brightness.light);
  static final ThemeData dark = _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF123F32),
          brightness: brightness,
        ).copyWith(
          primary: isLight ? const Color(0xFF123F32) : const Color(0xFFD6EF98),
          onPrimary: isLight
              ? const Color(0xFFF4F9ED)
              : const Color(0xFF123F32),
          surface: isLight ? const Color(0xFFF6F7F2) : const Color(0xFF111D19),
          surfaceContainerLowest: isLight
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF1B2A24),
          onSurface: isLight
              ? const Color(0xFF172F26)
              : const Color(0xFFEDF5EF),
          onSurfaceVariant: isLight
              ? const Color(0xFF607168)
              : const Color(0xFFA9BDB0),
          outline: isLight ? const Color(0xFF607168) : const Color(0xFFA9BDB0),
          outlineVariant: isLight
              ? const Color(0xFFE2E8DF)
              : const Color(0xFF34473C),
          error: isLight ? const Color(0xFFAD423C) : const Color(0xFFF2A29A),
          onError: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF521C18),
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [isLight ? ExchangeColors.light : ExchangeColors.dark],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surface,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      iconTheme: IconThemeData(color: scheme.onSurface),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: scheme.surfaceContainerLowest,
      ),
    );
  }
}
