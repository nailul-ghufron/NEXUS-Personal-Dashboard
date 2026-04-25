import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router.dart';
import 'core/theme/nexus_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:nexus_dashboard/shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('cache');

  final notificationService = NotificationService();
  await notificationService.init();

  await Supabase.initialize(
    url: 'https://mnxhkxcojjhqkeyzsjtj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ueGhreGNvampocWtleXpzanRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDcwMzUsImV4cCI6MjA5MjUyMzAzNX0.Y8UTTGSXbLQGOpP5urA5cVCFFRZsTb-pulbLVP1uKyM',
  );

  await initializeDateFormatting('id_ID', null);

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0'; // Replace with your actual DSN
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const ProviderScope(child: NexusApp())),
  );
}

class NexusApp extends ConsumerWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Nexus Dashboard',
      theme: nexusTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
