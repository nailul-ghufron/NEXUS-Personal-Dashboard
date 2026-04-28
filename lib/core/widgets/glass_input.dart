import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'glass_card.dart';

class GlassInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final bool useBlur;
  final int? maxLines;

  const GlassInput({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.autoFocus = false,
    this.maxLines = 1,
    this.useBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      useBlur: useBlur,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 16,
      height: maxLines == 1 ? 56 : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: maxLines == 1 ? 0 : 12),
        child: Center(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            autofocus: autoFocus,
            maxLines: maxLines,
            style: GoogleFonts.inter(color: NexusColors.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(color: NexusColors.textSecondary),
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              suffixIcon: suffixIcon,
              suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            ),
          ),
        ),
      ),
    );
  }
}

