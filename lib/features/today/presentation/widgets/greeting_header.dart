import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                'Selamat Pagi, Nailul',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.64,
                  color: NexusColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '✦',
              style: TextStyle(
                fontSize: 24,
                color: NexusColors.accentLavender,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'RABU, 23 APRIL 2026',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: NexusColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
