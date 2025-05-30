import 'package:flutter/material.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  static const String routeName = '/habits';

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Map<String, dynamic>> _habits = [
    {
      'name': 'Wake up at 6:00 AM',
      'completed': false,
      'streak': 0,
    },
    {
      'name': 'Exercise for 30 minutes',
      'completed': false,
      'streak': 0,
    },
    {
      'name': 'Meditate for 10 minutes',
      'completed': false,
      'streak': 0,
    },
  ];
  final TextEditingController _habitController = TextEditingController();

  void _addHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        _habits.add({
          'name': _habitController.text,
          'completed': false,
          'streak': 0,
        });
        _habitController.clear();
      });
    }
  }

  void _toggleHabitCompletion(int index) {
    setState(() {
      _habits[index]['completed'] = !_habits[index]['completed'];
      if (_habits[index]['completed']) {
        _habits[index]['streak'] = (_habits[index]['streak'] ?? 0) + 1;
      }
    });
  }

  void _deleteHabit(int index) {
    setState(() {
      _habits.removeAt(index);
    });
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
        title: const Text('Habits Tracker'),
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
              colorScheme.secondaryContainer.withOpacity(0.3),
              colorScheme.secondaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.mediumPadding),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _habitController,
                      decoration: InputDecoration(
                        hintText: 'Add a new habit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.smallPadding),
                  FilledButton(
                    onPressed: _addHabit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _habits.isEmpty
                  ? Center(
                      child: Text(
                        'No habits yet. Add one to get started!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _habits.length,
                      itemBuilder: (context, index) {
                        final habit = _habits[index];
                        return Dismissible(
                          key: Key(habit['name']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteHabit(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${habit['name']} deleted')),
                            );
                          },
                          background: Container(
                            color: colorScheme.error,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: AppTheme.mediumPadding),
                            child: Icon(
                              Icons.delete,
                              color: colorScheme.onError,
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppTheme.mediumPadding,
                              vertical: AppTheme.smallPadding,
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: Icon(
                                Icons.loop,
                                color: colorScheme.secondary,
                              ),
                              title: Text(
                                habit['name'],
                                style: TextStyle(
                                  decoration: habit['completed']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text('Streak: ${habit['streak'] ?? 0} days'),
                              trailing: Checkbox(
                                value: habit['completed'],
                                onChanged: (value) {
                                  _toggleHabitCompletion(index);
                                },
                                activeColor: colorScheme.secondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}