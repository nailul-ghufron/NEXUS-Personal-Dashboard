import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/constants/colors.dart';
import 'providers/checklist_provider.dart';
import 'widgets/progress_ring.dart';
import 'widgets/checklist_tile.dart';
import 'widgets/add_checklist_bottom_sheet.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(checklistProvider);

    return Scaffold(
      backgroundColor: NexusColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddChecklistBottomSheet(),
          );
        },
        backgroundColor: NexusColors.accentCyan,
        child: const Icon(LucideIcons.plus, color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Atmospheric backgrounds
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentCyan.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentCyan.withValues(alpha: 0.1), blurRadius: 120),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentBlue.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentBlue.withValues(alpha: 0.1), blurRadius: 100),
                  ],
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                Expanded(
                  child: checklistAsync.when(
                    data: (items) {
                      final completedCount = items.where((i) => i.isCompleted).length;
                      final totalCount = items.length;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          children: [
                            _buildDateNavigator(),
                            const SizedBox(height: 32),
                            ProgressRing(completed: completedCount, total: totalCount),
                            const SizedBox(height: 32),
                            _buildTabs(),
                            const SizedBox(height: 24),
                            _buildChecklist(ref, items),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentCyan)),
                    error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NexusColors.surfaceGlass,
              border: Border.all(color: NexusColors.glassBorder),
            ),
            child: const Icon(LucideIcons.user, size: 20, color: NexusColors.textSecondary),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'NEXUS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NexusColors.accentCyan,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings, color: NexusColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(LucideIcons.chevronLeft),
        Text(
          'Rabu, 23 Apr',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: NexusColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        _iconButton(LucideIcons.chevronRight),
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

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                'Harian',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'Mingguan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'Custom',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist(WidgetRef ref, List items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'No tasks found for today.',
            style: GoogleFonts.inter(color: NexusColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Opacity(
            opacity: item.isCompleted ? 0.5 : 1.0,
            child: ChecklistTile(
              title: item.title,
              subtitle: item.priority != 'Sedang' ? item.priority : null,
              isCompleted: item.isCompleted,
              onTap: () {
                ref.read(checklistProvider.notifier).toggleItem(item);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
