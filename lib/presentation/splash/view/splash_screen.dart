// import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:time_optimizer/core/routing/app_router.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  
  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withOpacity(0.8),
              colorScheme.secondary,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.extraLargeRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(AppTheme.mediumPadding),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 70,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.largePadding * 2),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Time Optimizer',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.largePadding),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Maximize your productivity',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.extraLargePadding * 2),
                  if (_controller.value > 0.6)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
