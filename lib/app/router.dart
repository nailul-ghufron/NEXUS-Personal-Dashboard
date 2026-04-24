import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/checklist/presentation/checklist_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/pomodoro/presentation/pomodoro_screen.dart';
import '../shared/navigation/bottom_nav.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

final router = GoRouter(
  initialLocation: '/today',
  observers: [SentryNavigatorObserver()],
  redirect: (context, state) {
    // Mocking Auth for layout building phase
    const bool isLoggedIn = true;
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
