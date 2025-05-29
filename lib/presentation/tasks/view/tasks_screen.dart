import 'package:flutter/material.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  static const String routeName = '/tasks';

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Task 1', 'completed': false},
    {'name': 'Task 2', 'completed': false},
    {'name': 'Task 3', 'completed': false},
  ];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          'name': _taskController.text,
          'completed': false,
        });
        _taskController.clear();
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
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
              colorScheme.tertiaryContainer.withAlpha(77),
              colorScheme.tertiaryContainer.withAlpha(26),
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
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task',
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
                    onPressed: _addTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.tertiary,
                      foregroundColor: colorScheme.onTertiary,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks yet. Add one to get started!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Dismissible(
                          key: Key(task['name']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteTask(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${task['name']} deleted')),
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
                                Icons.task_alt,
                                color: colorScheme.tertiary,
                              ),
                              title: Text(
                                task['name'],
                                style: TextStyle(
                                  decoration: task['completed']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: Checkbox(
                                value: task['completed'],
                                onChanged: (value) {
                                  _toggleTaskCompletion(index);
                                },
                                activeColor: colorScheme.tertiary,
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