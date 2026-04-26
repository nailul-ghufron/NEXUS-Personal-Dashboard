import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/colors.dart';
import '../../../app/providers/ui_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import 'providers/checklist_provider.dart';
import 'widgets/progress_ring.dart';
import 'widgets/checklist_tile.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(checklistProvider);
    
    // Listen to real-time date changes (every minute)
    ref.listen(realtimeDateProvider, (previous, next) {
      if (next.hasValue && previous != null && previous.hasValue && 
          previous.value?.day != next.value?.day) {
        // Date has changed! (It's midnight)
        // Reset daily tasks
        ref.read(checklistProvider.notifier).resetDailyTasks();
        // Update the selected date display
        ref.read(checklistSelectedDateProvider.notifier).setDate(next.value!);
      }
    });

    return Scaffold(
      backgroundColor: NexusColors.background,
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
                  color: NexusColors.accentLavender.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentLavender.withValues(alpha: 0.1), blurRadius: 120),
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
                  color: NexusColors.accentViolet.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentViolet.withValues(alpha: 0.1), blurRadius: 100),
                  ],
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, ref),
                Expanded(
                  child: checklistAsync.when(
                    data: (items) {
                      final currentFilter = ref.watch(checklistFilterProvider);
                      final filteredItems = items.where((item) => item.category == currentFilter).toList();
                      
                      final completedCount = filteredItems.where((i) => i.isCompleted).length;
                      final totalCount = filteredItems.length;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  _buildDateNavigator(ref),
                                  const SizedBox(height: 32),
                                  ProgressRing(completed: completedCount, total: totalCount),
                                  const SizedBox(height: 32),
                                  _buildTabs(ref),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                            _buildChecklist(ref, filteredItems),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final avatarUrl = user?.userMetadata?['avatar_url'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NexusColors.surfaceGlass,
                border: Border.all(color: NexusColors.glassBorder),
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) => const Icon(LucideIcons.user, size: 20, color: NexusColors.textSecondary),
                      )
                    : const Icon(LucideIcons.user, size: 20, color: NexusColors.textSecondary),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'NEXUS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NexusColors.accentLavender,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.settings, color: NexusColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator(WidgetRef ref) {
    final selectedDate = ref.watch(checklistSelectedDateProvider);
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
        _iconButton(
          LucideIcons.chevronLeft,
          onTap: () => ref.read(checklistSelectedDateProvider.notifier).previousDay(),
        ),
        Text(
          formattedDate,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: NexusColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        _iconButton(
          LucideIcons.chevronRight,
          onTap: () => ref.read(checklistSelectedDateProvider.notifier).nextDay(),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
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

  Widget _buildTabs(WidgetRef ref) {
    final currentFilter = ref.watch(checklistFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTabItem(ref, 'Harian', 'daily', currentFilter == 'daily'),
          _buildTabItem(ref, 'Mingguan', 'weekly', currentFilter == 'weekly'),
          _buildTabItem(ref, 'Custom', 'custom', currentFilter == 'custom'),
        ],
      ),
    );
  }

  Widget _buildTabItem(WidgetRef ref, String label, String value, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(checklistFilterProvider.notifier).setFilter(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? NexusColors.textPrimary : NexusColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklist(WidgetRef ref, List items) {
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'No tasks found for today.',
              style: GoogleFonts.inter(color: NexusColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Opacity(
            opacity: item.isCompleted ? 0.5 : 1.0,
            child: ChecklistTile(
              title: item.title,
              subtitle: null,
              isCompleted: item.isCompleted,
              onTap: () {
                ref.read(checklistProvider.notifier).toggleItem(item);
              },
              onDelete: () {
                ref.read(checklistProvider.notifier).removeItem(item.id);
              },
            ),
          ),
        );
      },
    );
  }
}
