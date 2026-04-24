import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/providers/ui_providers.dart';
import '../providers/schedule_provider.dart';
import '../../domain/models/schedule_item.dart';
import 'package:intl/intl.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final currentFilter = ref.watch(scheduleFilterProvider);

    return Column(
      children: [
        if (currentFilter == 0) _buildDateSelector(),
        if (currentFilter == 1) _buildWeeklyHeader(),
        if (currentFilter == 2) _buildCalendarPlaceholder(),
        const SizedBox(height: 16),
        scheduleAsync.when(
          data: (items) {
            List<ScheduleItem> filteredItems = items;
            
            if (currentFilter == 0) {
              // Today's filter (0=Mon in DB, DateTime.now().weekday is 1=Mon)
              final today = (DateTime.now().weekday - 1);
              filteredItems = items.where((item) => item.dayOfWeek == today).toList();
              // Sort by start time
              filteredItems.sort((a, b) => a.startTime.compareTo(b.startTime));
            } else if (currentFilter == 1) {
              // Weekly filter: sort by day then by time
              filteredItems = List.from(items);
              filteredItems.sort((a, b) {
                if (a.dayOfWeek != b.dayOfWeek) {
                  return a.dayOfWeek.compareTo(b.dayOfWeek);
                }
                return a.startTime.compareTo(b.startTime);
              });
            }

            if (filteredItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    currentFilter == 0 ? 'No schedule for today.' : 'No schedules found.',
                    style: GoogleFonts.inter(color: NexusColors.textSecondary),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                // Show day header if weekly view and day changed
                bool showDayHeader = currentFilter == 1 && 
                  (index == 0 || filteredItems[index-1].dayOfWeek != item.dayOfWeek);
                
                if (showDayHeader) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _getDayName(item.dayOfWeek),
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: NexusColors.accentLavender,
                          ),
                        ),
                      ),
                      _buildScheduleCard(item),
                    ],
                  );
                }
                return _buildScheduleCard(item);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: NexusColors.accentLavender),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMM', 'id_ID').format(now);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(Icons.chevron_left),
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: NexusColors.accentLavender,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              formattedDate,
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

  Widget _buildWeeklyHeader() {
    return Row(
      children: [
        const Icon(
          Icons.view_week,
          color: NexusColors.accentLavender,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Weekly Overview',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: NexusColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarPlaceholder() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.calendar_month, size: 64, color: NexusColors.textMuted),
          const SizedBox(height: 16),
          Text(
            'Calendar View Coming Soon',
            style: GoogleFonts.inter(color: NexusColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 0: return 'Senin';
      case 1: return 'Selasa';
      case 2: return 'Rabu';
      case 3: return 'Kamis';
      case 4: return 'Jumat';
      case 5: return 'Sabtu';
      case 6: return 'Minggu';
      default: return '';
    }
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
    final accentColor = isKampus
        ? NexusColors.accentLavender
        : NexusColors.accentViolet;
    final startTime = item.startTime;
    final endTime = item.endTime ?? '';
    final duration = endTime.isNotEmpty ? '$startTime - $endTime' : startTime;

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
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: NexusColors.glassBorder),
                ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.2),
                            ),
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
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: NexusColors.textSecondary,
                          ),
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
