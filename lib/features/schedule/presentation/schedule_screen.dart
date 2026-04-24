import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../app/providers/ui_providers.dart';
import 'widgets/day_view.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: NexusColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: NexusColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your classes and activities.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: NexusColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildTabBar(ref),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: DayView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(WidgetRef ref) {
    final currentFilter = ref.watch(scheduleFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexusColors.surface,
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTabItem(ref, 'Hari Ini', 0, currentFilter == 0),
          _buildTabItem(ref, 'Mingguan', 1, currentFilter == 1),
          _buildTabItem(ref, 'Kalender', 2, currentFilter == 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(WidgetRef ref, String label, int index, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(scheduleFilterProvider.notifier).setFilter(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? NexusColors.surfaceGlass : Colors.transparent,
            border: isSelected ? Border.all(color: NexusColors.glassBorder) : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]
              : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.6,
              color: isSelected ? NexusColors.textPrimary : NexusColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
