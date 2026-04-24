import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_card.dart';

class NextClassCard extends StatelessWidget {
  const NextClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'JADWAL BERIKUTNYA',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.4,
              color: NexusColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ),
        GlassCard(
          padding: const EdgeInsets.all(0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left accent bar
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: NexusColors.accentLavender,
                    boxShadow: [
                      BoxShadow(
                        color: NexusColors.accentLavender.withValues(alpha: 0.5),
                        blurRadius: 8,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Struktur Data & Algoritma',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: NexusColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 14, color: NexusColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '09:00 - 11:30',
                                        style: GoogleFonts.inter(fontSize: 14, color: NexusColors.textSecondary),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: CircleAvatar(radius: 2, backgroundColor: Colors.white24),
                                      ),
                                      const Icon(Icons.location_on, size: 14, color: NexusColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Ruang 302',
                                          style: GoogleFonts.inter(fontSize: 14, color: NexusColors.textSecondary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: NexusColors.accentLavender.withValues(alpha: 0.15),
                                border: Border.all(color: NexusColors.accentLavender.withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: NexusColors.accentLavender,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: NexusColors.accentLavender.withValues(alpha: 0.8),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dalam 45 Min',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: NexusColors.accentLavender,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: NexusColors.glassBorder, height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.assignment, size: 14, color: NexusColors.warning),
                            const SizedBox(width: 8),
                            Text(
                              'Tugas: Kumpulkan laporan Tree Traversal',
                              style: GoogleFonts.inter(fontSize: 14, color: NexusColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
