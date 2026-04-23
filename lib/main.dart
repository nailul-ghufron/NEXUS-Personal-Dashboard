import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'core/theme/nexus_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp() will be added once configured
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
