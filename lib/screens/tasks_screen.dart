import 'package:flutter/material.dart';

import '../models/care_task.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatelessWidget {
  final AppState appState;

  const TasksScreen({super.key, required this.appState});

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.red;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.low:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today’s Tasks')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: appState.tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final task = appState.tasks[index];
              final color = _priorityColor(task.priority);
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(appState: appState, task: task),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(task.completed ? Icons.check_rounded : Icons.schedule_rounded, color: color),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text('${task.residentName} • ${task.dueTime}', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
