import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
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
