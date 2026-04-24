import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

ThemeData nexusTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: NexusColors.background,
  colorScheme: const ColorScheme.dark(
    primary: NexusColors.accentLavender,
    secondary: NexusColors.accentViolet,
    surface: NexusColors.surface,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: NexusColors.textPrimary,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  fontFamily: GoogleFonts.inter().fontFamily,
  useMaterial3: true,
);
