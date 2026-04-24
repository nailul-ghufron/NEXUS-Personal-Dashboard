import 'package:flutter/material.dart';

class NexusColors {
  // Base
  static const background = Color(0xFF0C091A); // Deep Navy/Purple
  static const surface    = Color(0xFF16122C);
  static const surfaceGlass = Color(0x1AFFFFFF);

  // Accent
  static const accentViolet   = Color(0xFF8B5CF6);
  static const accentLavender = Color(0xFFA78BFA);
  static const accentGrad = LinearGradient(
    colors: [accentViolet, accentLavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted     = Color(0xFF475569);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger  = Color(0xFFEF4444);

  // Glass
  static const glassBorder    = Color(0x1AFFFFFF);  // white/10
  static const glassBlur      = 16.0;               // blur radius
}
