import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/domain/auth/entities/user_entity.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';
import 'package:time_optimizer/presentation/focus/view/focus_timer_screen.dart';
import 'package:time_optimizer/presentation/tasks/view/tasks_screen.dart';
import 'package:time_optimizer/presentation/habits/view/habits_screen.dart';
import 'package:time_optimizer/presentation/analytics/view/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;
  final _random = Random();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.mediumAnimation,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 180.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Time Optimizer',
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state.status == AuthStatus.authenticated ? state.user : null;
                  return IconButton(
                    icon: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      radius: 16,
                      child: user?.isNotEmpty == true
                          ? Text(
                              user!.email?.substring(0, 1).toUpperCase() ?? '?',
                              style: TextStyle(color: colorScheme.onPrimaryContainer),
                            )
                          : Icon(
                              Icons.person,
                              size: 16,
                              color: colorScheme.onPrimaryContainer,
                            ),
                    ),
                    onPressed: () {
                      _showUserMenu(context, user);
                    },
                  );
                },
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.mediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard header
                    const SizedBox(height: AppTheme.smallPadding),
                    Text(
                      'Your Dashboard',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.mediumPadding),
                    
                    // Focus Timer (Pomodoro)
                    _buildFeatureCard(
                      icon: Icons.timer,
                      title: 'Focus Timer',
                      subtitle: 'Boost productivity with timed work sessions',
                      color: colorScheme.primary,
                      progress: 0.0,
                      actionText: 'Start Focus',
                      onTap: () {
                        context.go(FocusTimerScreen.routeName);
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.mediumPadding),
                    
                    // Task Management
                    _buildFeatureCard(
                      icon: Icons.task_alt,
                      title: 'Tasks',
                      subtitle: 'Manage your daily tasks efficiently',
                      color: Colors.orange.shade700,
                      progress: _random.nextDouble() * 0.7 + 0.1,
                      actionText: 'View Tasks',
                      onTap: () {
                        context.go(TasksScreen.routeName);
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.mediumPadding),
                    
                    // Habit Tracking
                    _buildFeatureCard(
                      icon: Icons.loop,
                      title: 'Habits',
                      subtitle: 'Build better habits with consistent tracking',
                      color: Colors.green.shade700,
                      progress: _random.nextDouble() * 0.5 + 0.3,
                      actionText: 'Track Habits',
                      onTap: () {
                        context.go(HabitsScreen.routeName);
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.mediumPadding),
                    
                    // Analytics
                    _buildFeatureCard(
                      icon: Icons.bar_chart,
                      title: 'Analytics',
                      subtitle: 'Review your productivity performance',
                      color: Colors.purple.shade700,
                      progress: 0.0,
                      actionText: 'View Stats',
                      onTap: () {
                        context.go(AnalyticsScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Stats',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New task/timer creation coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required double progress,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.smallPadding),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: AppTheme.mediumPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (progress > 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppTheme.mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toInt()}% complete',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.mediumPadding),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: Icon(Icons.arrow_forward, size: 16),
                  label: Text(actionText),
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, UserEntity? user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.extraLargeRadius)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.largePadding,
            horizontal: AppTheme.mediumPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: user?.isNotEmpty == true
                      ? Text(user!.email?.substring(0, 1).toUpperCase() ?? '?')
                      : const Icon(Icons.person),
                ),
                title: Text(
                  user?.email ?? 'Guest User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Account Settings'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account settings coming soon!')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
