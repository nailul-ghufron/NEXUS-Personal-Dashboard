import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../checklist/presentation/providers/checklist_provider.dart';

class TodayHabitsCard extends ConsumerWidget {
  const TodayHabitsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(checklistProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'KEBIASAAN HARI INI',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.4,
              color: NexusColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ),
        checklistAsync.when(
          data: (items) {
            final dailyHabits = items.where((i) => i.category == 'daily').toList();
            if (dailyHabits.isEmpty) {
              return GlassCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada kebiasaan harian.',
                      style: GoogleFonts.inter(color: NexusColors.textSecondary),
                    ),
                  ),
                ),
              );
            }

            final completedCount = dailyHabits.where((i) => i.isCompleted).length;
            final totalCount = dailyHabits.length;
            final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
            final progressPercent = (progress * 100).toInt();

            // Limit to 4 items for the preview
            final displayHabits = dailyHabits.take(4).toList();

            return GlassCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 4,
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              color: NexusColors.accentLavender,
                            ),
                            Center(
                              child: Text(
                                '$progressPercent%',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: NexusColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            progressPercent == 100 ? 'Selesai!' : 'Mendekati Target',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: NexusColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$completedCount dari $totalCount kebiasaan selesai',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: NexusColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...displayHabits.map((habit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildHabitItem(ref, habit.id, habit.title, habit.isCompleted, habit),
                  )),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
          error: (e, _) => Center(child: Text('Error loading habits', style: GoogleFonts.inter(color: Colors.red))),
        ),
      ],
    );
  }

  Widget _buildHabitItem(WidgetRef ref, String id, String label, bool isDone, var item) {
    return GestureDetector(
      onTap: () {
        ref.read(checklistProvider.notifier).toggleItem(item);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? NexusColors.accentLavender.withValues(alpha: 0.2) : Colors.transparent,
                border: Border.all(
                  color: isDone ? NexusColors.accentLavender : Colors.white.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 18, color: NexusColors.accentLavender)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: isDone ? NexusColors.textSecondary : NexusColors.textPrimary,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white.withValues(alpha: 0.2),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
