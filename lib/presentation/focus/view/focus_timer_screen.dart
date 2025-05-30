import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  static const String routeName = '/focus-timer';

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  final int _workDuration = 25 * 60; // 25 minutes in seconds
  final int _breakDuration = 5 * 60; // 5 minutes in seconds
  int _totalTime = 25 * 60;
  int _timeLeft = 25 * 60;
  bool _isRunning = false;
  bool _isWorkSession = true;
  int _completedPomodoros = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _timeLeft = _workDuration;
    _totalTime = _workDuration;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() => _isRunning = true);
      _animationController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _isRunning = false;
            _animationController.stop();
            _animationController.value = 1.0;
            if (_isWorkSession) {
              _completedPomodoros++;
              _isWorkSession = false;
              _timeLeft = _breakDuration;
              _totalTime = _breakDuration;
            } else {
              _isWorkSession = true;
              _timeLeft = _workDuration;
              _totalTime = _workDuration;
            }
            // Play sound (simulated)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isWorkSession ? 'Work session started!' : 'Break time!')),
            );
          }
        });
      });
    }
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
    _animationController.stop();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _animationController.stop();
      _animationController.value = 1.0;
      _timeLeft = _workDuration;
      _totalTime = _workDuration;
      _isWorkSession = true;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Focus Timer'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withAlpha(77),
              colorScheme.primaryContainer.withAlpha(26),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isWorkSession ? 'Work Session' : 'Break Time',
                style: textTheme.headlineMedium?.copyWith(
                  color: _isWorkSession ? colorScheme.primary : colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(
                      value: _timeLeft / _totalTime,
                      strokeWidth: 12,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isWorkSession ? colorScheme.primary : colorScheme.secondary,
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      _formatTime(_timeLeft),
                      style: textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.largePadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.largePadding,
                        vertical: AppTheme.smallPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                      ),
                    ),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppTheme.mediumPadding),
                  if (_timeLeft != _totalTime)
                    OutlinedButton(
                      onPressed: _resetTimer,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(color: colorScheme.outline),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.largePadding,
                          vertical: AppTheme.smallPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                        ),
                      ),
                      child: const Icon(Icons.restart_alt, size: 32),
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Text(
                'Completed Pomodoros: $_completedPomodoros',
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}