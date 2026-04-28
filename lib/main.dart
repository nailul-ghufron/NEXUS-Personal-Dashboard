import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/router.dart';
import 'core/theme/nexus_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nexus_dashboard/shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Gagal memuat env: $e");
  }
  
  await Hive.initFlutter();

  await Future.wait([
    Hive.openBox('settings'),
    Hive.openBox('cache'),
    NotificationService().init(),
    Supabase.initialize(
      url: dotenv.get('api_url', fallback: 'https://mnxhkxcojjhqkeyzsjtj.supabase.co'),
      anonKey: dotenv.get('annon_public', fallback: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ueGhreGNvampocWtleXpzanRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDcwMzUsImV4cCI6MjA5MjUyMzAzNX0.Y8UTTGSXbLQGOpP5urA5cVCFFRZsTb-pulbLVP1uKyM'),
    ),
    initializeDateFormatting('id_ID', null),
  ]);

  runApp(const ProviderScope(child: NexusApp()));
}

class NexusApp extends ConsumerWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Nexus',
      theme: nexusTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
