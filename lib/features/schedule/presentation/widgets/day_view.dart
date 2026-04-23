import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../providers/schedule_provider.dart';
import '../../domain/models/schedule_item.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);

    return Column(
      children: [
        _buildDateSelector(),
        const SizedBox(height: 16),
        scheduleAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'No schedule for today.',
                    style: GoogleFonts.inter(color: NexusColors.textSecondary),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildScheduleCard(item);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentCyan)),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        ),
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

  Widget _buildScheduleCard(ScheduleItem item) {
    final isKampus = item.type == 'Kampus';
    final accentColor = isKampus ? NexusColors.accentCyan : NexusColors.warning;
    final startTime = DateFormat('HH:mm').format(item.startTime);
    final duration = '${item.endTime.difference(item.startTime).inHours} Jam';

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
                    color: accentColor.withValues(alpha: 0.5),
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
                            color: accentColor.withValues(alpha: 0.1),
                            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type,
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
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: NexusColors.textPrimary,
                      ),
                    ),
                    if (item.location != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: NexusColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            item.location!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: NexusColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
