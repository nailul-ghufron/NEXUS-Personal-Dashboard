import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';
import 'providers/pomodoro_provider.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    return Scaffold(
      backgroundColor: NexusColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Blobs
            Positioned(
              top: -100,
              right: -50,
              child: _buildBlob(NexusColors.accentLavender, 250),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: _buildBlob(NexusColors.accentViolet, 200),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Focus Timer',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay productive and manage your time',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: NexusColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Mode Selector
                  _buildModeSelector(pomodoro, notifier),
                  const SizedBox(height: 48),
                  
                  // Timer Display
                  _buildTimerDisplay(pomodoro),
                  const SizedBox(height: 48),
                  
                  // Controls
                  _buildControls(pomodoro, notifier),
                  const SizedBox(height: 48),
                  
                  // Stats
                  _buildStats(pomodoro),
                  const SizedBox(height: 120), // Bottom padding for navigation bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(PomodoroState state, PomodoroNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NexusColors.surfaceGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NexusColors.glassBorder),
      ),
      child: Row(
        children: [
          _modeButton('Pomodoro', PomodoroMode.work, state.mode, notifier),
          _modeButton('Short Break', PomodoroMode.shortBreak, state.mode, notifier),
          _modeButton('Long Break', PomodoroMode.longBreak, state.mode, notifier),
        ],
      ),
    );
  }

  Widget _modeButton(String label, PomodoroMode mode, PomodoroMode currentMode, PomodoroNotifier notifier) {
    final isSelected = mode == currentMode;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.setMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : NexusColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(PomodoroState state) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            value: state.progress,
            strokeWidth: 8,
            backgroundColor: NexusColors.surfaceGlass,
            valueColor: AlwaysStoppedAnimation<Color>(
              state.mode == PomodoroMode.work ? NexusColors.accentLavender : NexusColors.success,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.timeLeftFormatted,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              state.mode == PomodoroMode.work ? 'STAY FOCUSED' : 'TAKE A BREAK',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: NexusColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(PomodoroState state, PomodoroNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          icon: LucideIcons.rotateCcw,
          onTap: notifier.reset,
          color: NexusColors.textSecondary,
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: notifier.toggleTimer,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: NexusColors.accentGrad,
              boxShadow: [
                BoxShadow(
                  color: NexusColors.accentLavender.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              state.isRunning ? LucideIcons.pause : LucideIcons.play,
              size: 32,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 32),
        _controlButton(
          icon: LucideIcons.skipForward,
          onTap: () {
            // Logic to skip session could go here
          },
          color: NexusColors.textSecondary,
        ),
      ],
    );
  }

  Widget _controlButton({required IconData icon, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: NexusColors.surfaceGlass,
          border: Border.all(color: NexusColors.glassBorder),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
    );
  }

  Widget _buildStats(PomodoroState state) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Completed', '${state.completedSessions}', LucideIcons.circleCheck),
          Container(width: 1, height: 40, color: NexusColors.glassBorder),
          _statItem('Goal', '8', LucideIcons.target),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: NexusColors.accentLavender),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: NexusColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
