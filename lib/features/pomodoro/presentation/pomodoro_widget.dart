import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import 'providers/pomodoro_provider.dart';

class PomodoroWidget extends ConsumerWidget {
  const PomodoroWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: NexusColors.surface.withValues(alpha: 0.9),
        border: Border.all(color: NexusColors.glassBorder),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: NexusColors.warning, size: 16),
          const SizedBox(width: 12),
          Text(
            pomodoro.timeLeftFormatted,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: NexusColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => ref.read(pomodoroProvider.notifier).toggleTimer(),
            onLongPress: () => ref.read(pomodoroProvider.notifier).reset(),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                pomodoro.isRunning ? Icons.pause : Icons.play_arrow,
                color: NexusColors.textPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
