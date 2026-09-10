import 'package:flutter/material.dart';

@immutable
class ExchangeColors extends ThemeExtension<ExchangeColors> {
  const ExchangeColors({
    required this.heroBackground,
    required this.onHero,
    required this.heroAccent,
    required this.onHeroAccent,
    required this.heroDecoration,
    required this.strengthening,
    required this.weakening,
    required this.unchanged,
    required this.offlineBackground,
    required this.onOffline,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color heroBackground;
  final Color onHero;
  final Color heroAccent;
  final Color onHeroAccent;
  final Color heroDecoration;
  final Color strengthening;
  final Color weakening;
  final Color unchanged;
  final Color offlineBackground;
  final Color onOffline;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = ExchangeColors(
    heroBackground: Color(0xFF123F32),
    onHero: Color(0xFFF4F9ED),
    heroAccent: Color(0xFFD6EF98),
    onHeroAccent: Color(0xFF123F32),
    heroDecoration: Color(0xFF496B4C),
    strengthening: Color(0xFF237047),
    weakening: Color(0xFFAD423C),
    unchanged: Color(0xFF607168),
    offlineBackground: Color(0xFFFFF0CB),
    onOffline: Color(0xFF684B00),
    shimmerBase: Color(0xFFE2E8DF),
    shimmerHighlight: Color(0xFFF6F7F2),
  );

  static const dark = ExchangeColors(
    heroBackground: Color(0xFF234E3E),
    onHero: Color(0xFFF4F9ED),
    heroAccent: Color(0xFFD6EF98),
    onHeroAccent: Color(0xFF123F32),
    heroDecoration: Color(0xFF50765A),
    strengthening: Color(0xFF8FD2A6),
    weakening: Color(0xFFF2A29A),
    unchanged: Color(0xFFA9BDB0),
    offlineBackground: Color(0xFF44381B),
    onOffline: Color(0xFFF3D785),
    shimmerBase: Color(0xFF283D32),
    shimmerHighlight: Color(0xFF3C5547),
  );

  @override
  ExchangeColors copyWith({
    Color? heroBackground,
    Color? onHero,
    Color? heroAccent,
    Color? onHeroAccent,
    Color? heroDecoration,
    Color? strengthening,
    Color? weakening,
    Color? unchanged,
    Color? offlineBackground,
    Color? onOffline,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) => ExchangeColors(
    heroBackground: heroBackground ?? this.heroBackground,
    onHero: onHero ?? this.onHero,
    heroAccent: heroAccent ?? this.heroAccent,
    onHeroAccent: onHeroAccent ?? this.onHeroAccent,
    heroDecoration: heroDecoration ?? this.heroDecoration,
    strengthening: strengthening ?? this.strengthening,
    weakening: weakening ?? this.weakening,
    unchanged: unchanged ?? this.unchanged,
    offlineBackground: offlineBackground ?? this.offlineBackground,
    onOffline: onOffline ?? this.onOffline,
    shimmerBase: shimmerBase ?? this.shimmerBase,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
  );

  @override
  ExchangeColors lerp(ExchangeColors? other, double t) {
    if (other == null) return this;
    return ExchangeColors(
      heroBackground: Color.lerp(heroBackground, other.heroBackground, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      heroAccent: Color.lerp(heroAccent, other.heroAccent, t)!,
      onHeroAccent: Color.lerp(onHeroAccent, other.onHeroAccent, t)!,
      heroDecoration: Color.lerp(heroDecoration, other.heroDecoration, t)!,
      strengthening: Color.lerp(strengthening, other.strengthening, t)!,
      weakening: Color.lerp(weakening, other.weakening, t)!,
      unchanged: Color.lerp(unchanged, other.unchanged, t)!,
      offlineBackground: Color.lerp(
        offlineBackground,
        other.offlineBackground,
        t,
      )!,
      onOffline: Color.lerp(onOffline, other.onOffline, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}

extension ExchangeTheme on ThemeData {
  ExchangeColors get exchangeColors => extension<ExchangeColors>()!;
}
