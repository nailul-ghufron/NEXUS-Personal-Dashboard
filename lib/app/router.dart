import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/checklist/presentation/checklist_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/pomodoro/presentation/pomodoro_screen.dart';
import '../shared/navigation/bottom_nav.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/today',
    observers: [SentryNavigatorObserver()],
    redirect: (context, state) {
      final isLoggedIn = authState.value?.session != null;
      final isLogin = state.matchedLocation == '/login';
      if (!isLoggedIn && !isLogin) return '/login';
      if (isLoggedIn && isLogin) return '/today';
      return null;
    },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/today', builder: (_, __) => const TodayScreen()),
        GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),
        GoRoute(path: '/checklist', builder: (_, __) => const ChecklistScreen()),
        GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
        GoRoute(path: '/pomodoro', builder: (_, __) => const PomodoroScreen()),
      ],
    ),
  ],
);
});
