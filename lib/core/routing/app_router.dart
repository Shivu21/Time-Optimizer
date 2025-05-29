import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_optimizer/core/di/service_locator.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';
import 'package:time_optimizer/presentation/auth/view/login_screen.dart';
import 'package:time_optimizer/presentation/home/view/home_screen.dart';
import 'package:time_optimizer/presentation/focus/view/focus_timer_screen.dart';
import 'package:time_optimizer/presentation/habits/view/habits_screen.dart';
import 'package:time_optimizer/presentation/tasks/view/tasks_screen.dart';
import 'package:time_optimizer/presentation/analytics/view/analytics_screen.dart';
import 'package:time_optimizer/presentation/splash/view/splash_screen.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String focusTimerPath = '/focus-timer';
  static const String habitsPath = '/habits';
  static const String tasksPath = '/tasks';
  static const String analyticsPath = '/analytics';
  // static const String signupPath = '/signup'; // Example for later

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splashPath,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authBloc = sl<AuthBloc>();
      final authStatus = authBloc.state.status;
      final loggedIn = authStatus == AuthStatus.authenticated;
      final currentLocation = state.matchedLocation;

      // Log current state for debugging
      // print('Router Redirect: Current: $currentLocation, AuthStatus: $authStatus, LoggedIn: $loggedIn');

      // If authentication state is still unknown, stay on splash screen
      if (authStatus == AuthStatus.unknown) {
        return currentLocation == splashPath ? null : splashPath;
      }

      // Handle navigation from splash screen once auth state is known
      if (currentLocation == splashPath) {
        return loggedIn ? homePath : loginPath;
      }

      // Handle unauthenticated users
      if (!loggedIn) {
        // If not logged in, and not trying to access login (or other public paths like signup),
        // redirect to login.
        if (currentLocation != loginPath /* && currentLocation != signupPath */) {
          return loginPath;
        }
        return null; // Allow access to loginPath (and future public paths)
      }

      // Handle authenticated users
      if (loggedIn) {
        // If logged in and trying to access login page, redirect to home.
        if (currentLocation == loginPath) {
          return homePath;
        }
      }
      
      // No redirect needed for other cases (e.g., logged in and on a protected route)
      return null;
    },
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: focusTimerPath,
        builder: (context, state) => const FocusTimerScreen(),
      ),
      GoRoute(
        path: habitsPath,
        builder: (context, state) => const HabitsScreen(),
      ),
      GoRoute(
        path: tasksPath,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: analyticsPath,
        builder: (context, state) => const AnalyticsScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
