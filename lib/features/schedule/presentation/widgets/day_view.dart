import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';

class DayView extends StatelessWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateSelector(),
        const SizedBox(height: 16),
        _buildScheduleCard(
          startTime: '08:00',
          type: 'Kampus',
          duration: '2.5 Jam',
          title: 'Data Structures & Algorithms',
          location: 'Lab Komputer C101',
          isKampus: true,
        ),
        const SizedBox(height: 16),
        _buildScheduleCard(
          startTime: '18:30',
          type: "Ma'had",
          duration: '1.5 Jam',
          title: "Kajian Tafsir Al-Qur'an",
          location: 'Masjid Utama Kampus',
          isKampus: false,
        ),
        const SizedBox(height: 24),
        _buildEmptyState(),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(Icons.chevron_left),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: NexusColors.accentCyan, size: 20),
            const SizedBox(width: 8),
            Text(
              'Rabu, 23 Apr',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: NexusColors.textPrimary,
              ),
            ),
          ],
        ),
        _iconButton(Icons.chevron_right),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        shape: BoxShape.circle,
        border: Border.all(color: NexusColors.glassBorder),
      ),
      child: Icon(icon, color: NexusColors.textSecondary),
    );
  }

  Widget _buildScheduleCard({
    required String startTime,
    required String type,
    required String duration,
    required String title,
    required String location,
    required bool isKampus,
  }) {
    final accentColor = isKampus ? NexusColors.accentCyan : NexusColors.warning;

    return Container(
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.5),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
            Container(
              width: 70,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: NexusColors.glassBorder)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MULAI',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: NexusColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    startTime,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: NexusColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            border: Border.all(color: accentColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ),
                        Text(
                          duration,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: NexusColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: NexusColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: NexusColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          location,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: NexusColors.textSecondary,
                          ),
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass.withOpacity(0.02),
        border: Border.all(color: NexusColors.glassBorder, style: BorderStyle.solid),
        // Wait, dashed border is not easily supported in Flutter without packages
        // Let's stick to a subtle solid border
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.coffee, color: NexusColors.textMuted),
          const SizedBox(width: 8),
          Text(
            'Waktu kosong hingga 18:30',
            style: GoogleFonts.inter(color: NexusColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
