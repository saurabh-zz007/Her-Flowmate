import 'package:flutter/material.dart';

abstract final class AppTheme {
  // Refined Peach Palette
  static const Color frameColor = Color(0xFFFFF7F3); // Very soft peach
  static const Color accentPink = Color(0xFFFF8571); // Soft Coral
  static const Color shadowDark = Color(0xFFE8D6CB); 
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF6B5E5E);

  static BoxDecoration glassDecoration({double radius = 24.0, Color? color}) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(0.4),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
    );
  }

  // Gradient background
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFBF9),
      Color(0xFFFFF7F3),
    ],
  );

  // Phase colors (refined)
  static const Map<String, Color> phaseColors = {
    'Menstrual': Color(0xFFF06292),
    'Follicular': Color(0xFFF8BBD0),
    'Ovulation': Color(0xFFBA68C8),
    'Fertile': Color(0xFFF48FB1),
    'Luteal': Color(0xFFE1BEE7),
  };

  static const Color neuSurface = frameColor;
  static const Color neuBackground = frameColor;
  static const Color neuShadowDark = shadowDark;
  static const Color neuShadowLight = shadowLight;
  static const Color textMain = textDark;
  static Color get textMuted => textDark.withOpacity(0.6);

  static const Color accentPurple = Color(0xFFBA68C8);
  static const Color accentCyan = Color(0xFF4DD0E1);
  static const Color neonGreen = Color(0xFF81C784);

  // Phase tip helper
  static ({String headline, String body}) phaseTip(String phase) {
    switch (phase) {
      case 'Menstrual':
        return (headline: 'Focus on Rest', body: 'Your energy might be lower. Be gentle with yourself.');
      case 'Follicular':
        return (headline: 'Higher Energy', body: 'A great time for new projects and exercise.');
      case 'Ovulation':
        return (headline: 'Peak Fertility', body: 'You may feel more social and vibrant today.');
      case 'Luteal':
        return (headline: 'PMS Support', body: 'Prioritize self-care and balanced nutrition.');
      default:
        return (headline: 'Keep Logged', body: 'Continue tracking for better predictions!');
    }
  }

  static Color phaseColor(String phase) => phaseColors[phase] ?? accentPink;

  // Neumorphic decoration helper
  static BoxDecoration neuDecoration({
    double radius = 28.0,
    Color color = frameColor,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: shadowDark,
                offset: const Offset(2, 2),
                blurRadius: 5,
                blurStyle: BlurStyle.inner,
              ),
              BoxShadow(
                color: shadowLight,
                offset: const Offset(-2, -2),
                blurRadius: 5,
                blurStyle: BlurStyle.inner,
              ),
            ]
          : [
              BoxShadow(
                color: shadowDark,
                offset: const Offset(6, 6),
                blurRadius: 15,
              ),
              BoxShadow(
                color: shadowLight,
                offset: const Offset(-6, -6),
                blurRadius: 15,
              ),
            ],
    );
  }

  // Inner inset decoration helper
  static BoxDecoration neuInnerDecoration({
    double radius = 28.0,
    Color color = frameColor,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: shadowLight,
          offset: Offset(2, 2),
          blurRadius: 5,
          blurStyle: BlurStyle.inner,
        ),
        BoxShadow(
          color: shadowDark,
          offset: Offset(-2, -2),
          blurRadius: 5,
          blurStyle: BlurStyle.inner,
        ),
      ],
    );
  }
}
