import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../features/schedule/presentation/widgets/add_schedule_bottom_sheet.dart';
import '../../features/checklist/presentation/widgets/add_checklist_bottom_sheet.dart';
import '../../features/notes/presentation/widgets/add_note_dialog.dart';
import '../../features/pomodoro/presentation/pomodoro_widget.dart';
import '../../app/providers/ui_providers.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final isPomodoro = location == '/pomodoro';
    final isFabVisible = ref.watch(fabVisibilityProvider) && !isPomodoro;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.scrollDelta! > 2 && isFabVisible) {
              ref.read(fabVisibilityProvider.notifier).hide();
            } else if (notification.scrollDelta! < -2 && !isFabVisible) {
              ref.read(fabVisibilityProvider.notifier).show();
            }
          }
          return false;
        },
        child: child,
      ),
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 0),
        child: AnimatedScale(
          scale: isFabVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: isFabVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              onPressed: () {
                final location = GoRouterState.of(context).matchedLocation;
                if (location == '/schedule') {
                  _showAddSheet(context, const AddScheduleBottomSheet());
                } else if (location == '/checklist') {
                  _showAddSheet(context, const AddChecklistBottomSheet());
                } else if (location == '/notes') {
                  showDialog(
                    context: context,
                    builder: (context) => const AddNoteDialog(),
                  );
                } else if (location == '/today') {
                  _showAddSheet(context, const AddChecklistBottomSheet());
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: NexusColors.accentGrad,
                  boxShadow: [
                    BoxShadow(
                      color: NexusColors.accentLavender.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.plus,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PomodoroWidget(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: GlassCard(
              borderRadius: 32,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(context, LucideIcons.house, '/today'),
                  _buildNavItem(context, LucideIcons.calendar, '/schedule'),
                  _buildNavItem(context, LucideIcons.timer, '/pomodoro'),
                  _buildNavItem(context, LucideIcons.listTodo, '/checklist'),
                  _buildNavItem(context, LucideIcons.stickyNote, '/notes'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String path) {
    final bool isSelected = GoRouterState.of(context).matchedLocation == path;
    return IconButton(
      icon: Icon(icon),
      color: isSelected
          ? NexusColors.accentLavender
          : NexusColors.textSecondary,
      onPressed: () => context.go(path),
    );
  }

  void _showAddSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => sheet,
    );
  }
}
