import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/providers/ui_providers.dart';
import '../../domain/models/schedule_item.dart';
import '../providers/schedule_provider.dart';
import 'add_schedule_bottom_sheet.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final selectedDate = ref.watch(calendarSelectedDateProvider);

    return scheduleAsync.when(
      data: (items) {
        return Column(
          children: [
            _buildCalendar(ref, selectedDate, items),
            const SizedBox(height: 24),
            _buildSelectedDaySchedules(ref, selectedDate, items),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
    );
  }

  Widget _buildCalendar(WidgetRef ref, DateTime selectedDate, List<ScheduleItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NexusColors.glassBorder),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2026, 12, 31),
        focusedDay: selectedDate,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(calendarSelectedDateProvider.notifier).setDate(selectedDay);
        },
        eventLoader: (day) {
          // day.weekday: 1=Mon, 7=Sun
          // DB day_of_week: 0=Mon, 6=Sun
          final dbDay = day.weekday - 1;
          return items.where((item) => item.dayOfWeek == dbDay).toList();
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.inter(
            color: NexusColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: NexusColors.accentLavender),
          rightChevronIcon: const Icon(Icons.chevron_right, color: NexusColors.accentLavender),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: NexusColors.accentLavender.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: NexusColors.accentLavender,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: NexusColors.accentViolet,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: GoogleFonts.inter(color: NexusColors.textPrimary),
          weekendTextStyle: GoogleFonts.inter(color: NexusColors.accentViolet),
          outsideTextStyle: GoogleFonts.inter(color: NexusColors.textMuted),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(color: NexusColors.textSecondary, fontWeight: FontWeight.w600),
          weekendStyle: GoogleFonts.inter(color: NexusColors.accentViolet, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSelectedDaySchedules(WidgetRef ref, DateTime selectedDate, List<ScheduleItem> items) {
    // DB day_of_week: 0=Mon, 6=Sun
    final dbDay = selectedDate.weekday - 1;
    final dailySchedules = items.where((item) => item.dayOfWeek == dbDay).toList();
    dailySchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

    if (dailySchedules.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'No schedules for this day.',
            style: GoogleFonts.inter(color: NexusColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Schedule for ${selectedDate.day}/${selectedDate.month}',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NexusColors.accentLavender,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailySchedules.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = dailySchedules[index];
            return _buildInteractiveScheduleCard(context, ref, item);
          },
        ),
      ],
    );
  }

  Widget _buildInteractiveScheduleCard(BuildContext context, WidgetRef ref, ScheduleItem item) {
    return _buildSimpleScheduleCard(context, ref, item);
  }

  void _showEditSheet(BuildContext context, ScheduleItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddScheduleBottomSheet(item: item),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, ScheduleItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NexusColors.background,
        title: Text('Delete Schedule?', style: GoogleFonts.inter(color: Colors.white)),
        content: Text('Are you sure you want to delete "${item.title}"?', 
          style: GoogleFonts.inter(color: NexusColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: NexusColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(scheduleProvider.notifier).removeSchedule(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleScheduleCard(BuildContext context, WidgetRef ref, ScheduleItem item) {
    final isKampus = item.type == 'campus';
    final accentColor = isKampus ? NexusColors.accentLavender : NexusColors.accentViolet;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NexusColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    color: NexusColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${item.startTime}${item.endTime != null ? ' - ${item.endTime}' : ''} • ${item.location ?? 'No location'}',
                  style: GoogleFonts.inter(
                    color: NexusColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionIcon(
                      Icons.edit_outlined,
                      NexusColors.accentLavender,
                      () => _showEditSheet(context, item),
                    ),
                    const SizedBox(width: 12),
                    _buildActionIcon(
                      Icons.delete_outline,
                      Colors.red.withValues(alpha: 0.7),
                      () => _showDeleteConfirmation(context, ref, item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
