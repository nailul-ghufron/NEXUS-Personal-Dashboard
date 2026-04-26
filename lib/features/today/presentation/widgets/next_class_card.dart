import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../schedule/presentation/providers/schedule_provider.dart';

class NextClassCard extends ConsumerWidget {
  const NextClassCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);

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
        scheduleAsync.when(
          data: (items) {
            final now = DateTime.now();
            final todayIndex = now.weekday - 1; // 0=Mon, 6=Sun in DB
            
            final todaysSchedules = items.where((i) => i.dayOfWeek == todayIndex).toList();
            todaysSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

            // Find the *next* schedule (or current one if it hasn't ended)
            final currentTimeInt = now.hour * 60 + now.minute;
            
            var nextSchedule = todaysSchedules.cast().firstWhere(
              (item) {
                final startParts = item.startTime.split(':');
                final startMins = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
                
                int endMins = startMins + 60; // Default to 1 hour duration if no end time
                if (item.endTime != null && item.endTime!.isNotEmpty) {
                  final endParts = item.endTime!.split(':');
                  endMins = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
                }
                
                // Keep showing it if it hasn't ended yet
                return endMins > currentTimeInt;
              },
              orElse: () => null,
            );

            if (nextSchedule == null) {
              return GlassCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Tidak ada jadwal lagi untuk hari ini.',
                    style: GoogleFonts.inter(color: NexusColors.textSecondary),
                  ),
                ),
              );
            }

            // Calculate "Dalam X Min"
            String timeUntil = '';
            final startParts = nextSchedule.startTime.split(':');
            final startMins = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
            final diff = startMins - currentTimeInt;
            
            if (diff <= 0) {
              timeUntil = 'Sedang Berlangsung';
            } else if (diff < 60) {
              timeUntil = 'Dalam $diff Min';
            } else {
              final h = diff ~/ 60;
              final m = diff % 60;
              timeUntil = 'Dalam $h Jam${m > 0 ? ' $m Min' : ''}';
            }

            final isKampus = nextSchedule.type == 'campus';
            final accentColor = isKampus ? NexusColors.accentLavender : NexusColors.accentViolet;

            return GlassCard(
              padding: const EdgeInsets.all(0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.5),
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
                                        nextSchedule.title,
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
                                            '${nextSchedule.startTime}${nextSchedule.endTime != null ? ' - ${nextSchedule.endTime}' : ''}',
                                            style: GoogleFonts.inter(fontSize: 14, color: NexusColors.textSecondary),
                                          ),
                                          if (nextSchedule.location != null) ...[
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: CircleAvatar(radius: 2, backgroundColor: Colors.white24),
                                            ),
                                            const Icon(Icons.location_on, size: 14, color: NexusColors.textSecondary),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                nextSchedule.location!,
                                                style: GoogleFonts.inter(fontSize: 14, color: NexusColors.textSecondary),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.15),
                                    border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: accentColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: accentColor.withValues(alpha: 0.8),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        timeUntil,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
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
          },
          loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
          error: (e, _) => Center(child: Text('Error loading schedule', style: GoogleFonts.inter(color: Colors.red))),
        ),
      ],
    );
  }
}
