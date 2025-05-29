
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:time_optimizer/core/di/service_locator.dart';
import 'package:time_optimizer/core/routing/app_router.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize service locator (now using MockAuthRepositoryImpl)
  await initServiceLocator();

  // Font pre-loading removed to prevent network errors during startup.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}
