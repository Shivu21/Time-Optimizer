<<<<<<< HEAD
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
=======
// import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:time_optimizer/core/routing/app_router.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';
>>>>>>> 0c6f5c7 (feat: implement back navigation and update routing from go() to push())

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _navigateToNextScreen();
=======
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeInOut)));
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack)));
    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeInOut)));
    _controller.forward();
    Timer(const Duration(seconds: 5), () {
      final authStatus = context.read<AuthBloc>().state.status;
      if (authStatus == AuthStatus.authenticated) {
        context.go(AppRouter.homePath);
      } else {
        context.go(AppRouter.loginPath);
      }
    });
>>>>>>> 0c6f5c7 (feat: implement back navigation and update routing from go() to push())
  }

  void _navigateToNextScreen() {
    // Wait for 3 seconds and then navigate to the login screen.
    // This is a temporary fix to get past the splash screen.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Use GoRouter to navigate to the login page.
        // This assumes a route named '/login' is defined in your AppRouter.
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
