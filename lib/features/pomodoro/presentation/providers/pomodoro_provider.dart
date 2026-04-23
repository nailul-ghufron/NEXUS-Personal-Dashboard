import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroState {
  final int timeLeft;
  final bool isRunning;
  final bool isBreak;

  PomodoroState({
    this.timeLeft = 25 * 60,
    this.isRunning = false,
    this.isBreak = false,
  });

  PomodoroState copyWith({int? timeLeft, bool? isRunning, bool? isBreak}) {
    return PomodoroState(
      timeLeft: timeLeft ?? this.timeLeft,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
    );
  }

  String get timeLeftFormatted {
    final minutes = (timeLeft / 60).floor().toString().padLeft(2, '0');
    final seconds = (timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  Timer? _timer;

  PomodoroNotifier() : super(PomodoroState());

  void toggleTimer() {
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(isRunning: false);
    } else {
      state = state.copyWith(isRunning: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.timeLeft > 0) {
          state = state.copyWith(timeLeft: state.timeLeft - 1);
        } else {
          _timer?.cancel();
          state = state.copyWith(isRunning: false);
          // Handle switch to break or session end logic here
        }
      });
    }
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});
