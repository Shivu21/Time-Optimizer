import 'package:flutter/material.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const String routeName = '/analytics';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Dummy data for analytics
    final int completedTasks = 15;
    final int activeTasks = 5;
    final int completedHabits = 3;
    final int totalPomodoros = 20;
    final List<double> productivityData = [5.0, 7.0, 3.0, 8.0, 6.0, 9.0, 4.0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Analytics'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Overview',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Productivity Trend',
                        style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: AppTheme.smallPadding),
                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: ProductivityChartPainter(
                            data: productivityData,
                            lineColor: colorScheme.primary,
                            fillColor: colorScheme.primary.withAlpha(51),
                          ),
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.mediumPadding),
                        child: Column(
                          children: [
                            Icon(
                              Icons.task_alt,
                              color: colorScheme.tertiary,
                              size: 32,
                            ),
                            const SizedBox(height: AppTheme.smallPadding),
                            Text(
                              'Tasks Completed',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              '$completedTasks',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.mediumPadding),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.mediumPadding),
                        child: Column(
                          children: [
                            Icon(
                              Icons.timer,
                              color: colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(height: AppTheme.smallPadding),
                            Text(
                              'Pomodoros',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              '$totalPomodoros',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.mediumPadding),
                        child: Column(
                          children: [
                            Icon(
                              Icons.loop,
                              color: colorScheme.secondary,
                              size: 32,
                            ),
                            const SizedBox(height: AppTheme.smallPadding),
                            Text(
                              'Habits Completed',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              '$completedHabits',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.mediumPadding),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.mediumPadding),
                        child: Column(
                          children: [
                            Icon(
                              Icons.pending_actions,
                              color: colorScheme.error,
                              size: 32,
                            ),
                            const SizedBox(height: AppTheme.smallPadding),
                            Text(
                              'Active Tasks',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              '$activeTasks',
                              style: textTheme.displaySmall?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.mediumPadding),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Summary',
                        style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: AppTheme.smallPadding),
                      Text(
                        'You have completed $completedTasks tasks and $completedHabits habits this week. Keep up the good work!',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductivityChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  ProductivityChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double width = size.width;
    final double height = size.height;
    final double xStep = width / (data.length - 1);
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double valueRange = maxValue - minValue;

    // Draw grid lines
    final Paint gridPaint = Paint()
      ..color = Colors.grey.withAlpha(77)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 5; i++) {
      final double y = height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Draw the line chart
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    Path linePath = Path();
    Path fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final double x = xStep * i;
      final double normalizedValue = valueRange != 0
          ? (data[i] - minValue) / valueRange
          : 0.5; // Default to middle if no range
      final double y = height - (height * normalizedValue);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(width, height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}