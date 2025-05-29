import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:time_optimizer/core/di/service_locator.dart';
import 'package:time_optimizer/core/routing/app_router.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Perform initialization in background
  _initializeApp();
}

Future<void> _initializeApp() async {
  // Initialize Hive only if not on web
  if (!kIsWeb) {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
  } else {
    // For web, init without a path or use a different storage solution
    await Hive.initFlutter();
  }

  // Register Hive adapters and open boxes
  // Temporarily comment out due to adapter issue
  // Hive.registerAdapter(UserEntityAdapter());
  // await Hive.openBox<UserEntity>('userBox');

  // Initialize service locator
  await initServiceLocator();

  // Ensure no duplicate registration to avoid conflict with service_locator.dart
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl<AuthRepository>()));
  }

  runApp(const MyApp());

  // Preload Google Fonts to avoid text flicker
  await GoogleFonts.pendingFonts([  
    GoogleFonts.poppins(),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Time Optimizer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Automatically switches between light and dark
        routerConfig: AppRouter.router,
        // Make app responsive with proper scrolling on all devices
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown
          },
        ),
      ),
    );
  }
}
