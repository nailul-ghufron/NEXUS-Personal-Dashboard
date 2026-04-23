import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';

class ProgressRing extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressRing({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = total == 0 ? 0 : completed / total;

    return Column(
      children: [
        SizedBox(
          width: 192,
          height: 192,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 6,
                color: Colors.white.withOpacity(0.05),
              ),
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 6,
                backgroundColor: Colors.transparent,
                color: NexusColors.accentCyan,
              ),
              // Shadow for glow effect
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: NexusColors.accentCyan.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: -10,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$completed',
                            style: GoogleFonts.inter(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: NexusColors.textPrimary,
                              letterSpacing: -2,
                            ),
                          ),
                          TextSpan(
                            text: '/$total',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: NexusColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'COMPLETED',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: NexusColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
