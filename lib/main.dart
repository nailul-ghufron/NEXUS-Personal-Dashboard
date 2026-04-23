import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router.dart';
import 'core/theme/nexus_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://mnxhkxcovjjhqkeyzsjtj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ueGhreGNvampocWtleXpzanRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDcwMzUsImV4cCI6MjA5MjUyMzAzNX0.Y8UTTGSXbLQGOpP5urA5cVCFFRZsTb-pulbLVP1uKyM',
  );

  runApp(const ProviderScope(child: NexusApp()));
}

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nexus Dashboard',
      theme: nexusTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
