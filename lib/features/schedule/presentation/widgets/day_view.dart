import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/providers/ui_providers.dart';
import '../providers/schedule_provider.dart';
import '../../domain/models/schedule_item.dart';
import 'calendar_view.dart';
import 'add_schedule_bottom_sheet.dart';
import 'package:intl/intl.dart';

class DayView extends ConsumerWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final currentFilter = ref.watch(scheduleFilterProvider);

    return CustomScrollView(
      slivers: [
        if (currentFilter == 0) SliverToBoxAdapter(child: _buildDateSelector(ref)),
        if (currentFilter == 1) SliverToBoxAdapter(child: _buildWeeklyHeader()),
        if (currentFilter == 2) const SliverToBoxAdapter(child: CalendarView()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        scheduleAsync.when(
          data: (items) {
            List<ScheduleItem> filteredItems = items;
            
            if (currentFilter == 0) {
              final selectedDate = ref.watch(scheduleSelectedDateProvider);
              final today = (selectedDate.weekday - 1);
              debugPrint('Selected weekday index (DB format): $today');
              filteredItems = items.where((item) => item.dayOfWeek == today).toList();
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
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      currentFilter == 0 ? 'No schedule for today.' : 'No schedules found.',
                      style: GoogleFonts.inter(color: NexusColors.textSecondary),
                    ),
                  ),
                ),
              );
            }

            return SliverList.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                bool showDayHeader = currentFilter == 1 && 
                  (index == 0 || filteredItems[index-1].dayOfWeek != item.dayOfWeek);
                
                Widget card = _buildInteractiveScheduleCard(context, ref, item);
                
                if (showDayHeader) {
                  card = Column(
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
                      card,
                    ],
                  );
                }

                // Add separator logic directly in builder
                return Padding(
                  padding: EdgeInsets.only(bottom: index == filteredItems.length - 1 ? 0 : 16.0),
                  child: card,
                );
              },
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(color: NexusColors.accentLavender),
            ),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 150)),
      ],
    );
  }

  Widget _buildDateSelector(WidgetRef ref) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final now = DateTime.now();
    final isToday = selectedDate.day == now.day &&
                    selectedDate.month == now.month &&
                    selectedDate.year == now.year;
                    
    final formattedDate = isToday
        ? 'Hari Ini, ${DateFormat('d MMM', 'id_ID').format(selectedDate)}'
        : DateFormat('EEEE, d MMM', 'id_ID').format(selectedDate);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(Icons.chevron_left, () {
          ref.read(scheduleSelectedDateProvider.notifier).previousDay();
        }),
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
        _iconButton(Icons.chevron_right, () {
          ref.read(scheduleSelectedDateProvider.notifier).nextDay();
        }),
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

  Widget _iconButton(IconData icon, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: NexusColors.surfaceGlass,
          shape: BoxShape.circle,
          border: Border.all(color: NexusColors.glassBorder),
        ),
        child: Icon(icon, color: NexusColors.textSecondary),
      ),
    );
  }

  Widget _buildInteractiveScheduleCard(BuildContext context, WidgetRef ref, ScheduleItem item) {
    return _buildScheduleCard(context, ref, item);
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

  Widget _buildScheduleCard(BuildContext context, WidgetRef ref, ScheduleItem item) {
    final isKampus = item.type == 'campus';
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
            ),
          ],
        ),
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
