import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

enum PomodoroMode {
  work,
  shortBreak,
  longBreak,
}

class PomodoroState {
  final int timeLeft;
  final bool isRunning;
  final PomodoroMode mode;
  final int completedSessions;

  PomodoroState({
    this.timeLeft = 25 * 60,
    this.isRunning = false,
    this.mode = PomodoroMode.work,
    this.completedSessions = 0,
  });

  PomodoroState copyWith({
    int? timeLeft,
    bool? isRunning,
    PomodoroMode? mode,
    int? completedSessions,
  }) {
    return PomodoroState(
      timeLeft: timeLeft ?? this.timeLeft,
      isRunning: isRunning ?? this.isRunning,
      mode: mode ?? this.mode,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  String get timeLeftFormatted {
    final minutes = (timeLeft / 60).floor().toString().padLeft(2, '0');
    final seconds = (timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    int total;
    switch (mode) {
      case PomodoroMode.work:
        total = 25 * 60;
        break;
      case PomodoroMode.shortBreak:
        total = 5 * 60;
        break;
      case PomodoroMode.longBreak:
        total = 15 * 60;
        break;
    }
    return 1 - (timeLeft / total);
  }
}

class PomodoroNotifier extends Notifier<PomodoroState> {
  Timer? _timer;
  late final AudioPlayer _audioPlayer;

  @override
  PomodoroState build() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.audioCache = AudioCache(prefix: '');
    ref.onDispose(() {
      _timer?.cancel();
      _audioPlayer.dispose();
    });
    return PomodoroState();
  }

  void setMode(PomodoroMode mode) {
    _timer?.cancel();
    int time;
    switch (mode) {
      case PomodoroMode.work:
        time = 25 * 60;
        break;
      case PomodoroMode.shortBreak:
        time = 5 * 60;
        break;
      case PomodoroMode.longBreak:
        time = 15 * 60;
        break;
    }
    state = state.copyWith(
      mode: mode,
      timeLeft: time,
      isRunning: false,
    );
  }

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
          _handleSessionComplete();
        }
      });
    }
  }

  void _handleSessionComplete() {
    _playAlarm();
    if (state.mode == PomodoroMode.work) {
      final newSessions = state.completedSessions + 1;
      state = state.copyWith(
        isRunning: false,
        completedSessions: newSessions,
      );
    } else {
      state = state.copyWith(isRunning: false);
    }
  }

  Future<void> _playAlarm() async {
    String assetPath;
    switch (state.mode) {
      case PomodoroMode.work:
        assetPath = 'Sound_Alarm/soundreality-alarm-471496.mp3';
        break;
      case PomodoroMode.shortBreak:
        assetPath = 'Sound_Alarm/soundsgoodmusic-alarm-2-375697.mp3';
        break;
      case PomodoroMode.longBreak:
        assetPath = 'Sound_Alarm/u_inx5oo5fv3-alarm-327234.mp3';
        break;
    }
    
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Log error if needed
    }
  }

  void reset() {
    _timer?.cancel();
    setMode(state.mode);
  }
}

final pomodoroProvider = NotifierProvider<PomodoroNotifier, PomodoroState>(() {
  return PomodoroNotifier();
});
