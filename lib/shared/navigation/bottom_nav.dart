import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/glass_card.dart';

import '../../features/pomodoro/presentation/pomodoro_widget.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PomodoroWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: GlassCard(
                borderRadius: 32,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(context, LucideIcons.house, '/today'),
                    _buildNavItem(context, LucideIcons.calendar, '/schedule'),
                    _buildFab(context),
                    _buildNavItem(context, LucideIcons.checkSquare, '/checklist'),
                    _buildNavItem(context, LucideIcons.stickyNote, '/notes'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String path) {
    final bool isSelected = GoRouterState.of(context).matchedLocation == path;
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? NexusColors.accentCyan : NexusColors.textSecondary,
      onPressed: () => context.go(path),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: NexusColors.accentGrad,
        boxShadow: [
          BoxShadow(
            color: NexusColors.accentCyan.withValues(alpha: 0.5),
            blurRadius: 16,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        onPressed: () {
          // Implement FAB expand menu
        },
      ),
    );
  }
}
