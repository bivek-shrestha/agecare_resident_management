import 'package:flutter/material.dart';

import '../models/care_task.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'resident_detail_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final AppState appState;
  final CareTask task;

  const TaskDetailScreen({
    super.key,
    required this.appState,
    required this.task,
  });

  Color get priorityColor {
    switch (task.priority) {
      case TaskPriority.high:
        return AppColors.red;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.low:
        return AppColors.green;
    }
  }

  String get priorityLabel {
    switch (task.priority) {
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.low:
        return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  priorityLabel,
                                  style: TextStyle(
                                    color: priorityColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _TaskRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Resident',
                            value: task.residentName,
                          ),
                          _TaskRow(
                            icon: Icons.schedule_rounded,
                            label: 'Due time',
                            value: task.dueTime,
                          ),
                          _TaskRow(
                            icon: Icons.badge_outlined,
                            label: 'Assigned to',
                            value: task.assignedTo,
                          ),
                          const Divider(height: 28),
                          const Text(
                            'Instructions',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.instructions,
                            style: const TextStyle(
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (task.completed) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.green.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'This care task has been completed.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final viewResident = OutlinedButton.icon(
                        onPressed: () => _openResident(context),
                        icon: const Icon(Icons.person_search_rounded),
                        label: const Text('View Resident'),
                      );
                      final completeTask = FilledButton.icon(
                        onPressed: () {
                          appState.setTaskCompleted(task.id, !task.completed);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                task.completed
                                    ? 'Task marked complete.'
                                    : 'Task reopened.',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          task.completed
                              ? Icons.refresh_rounded
                              : Icons.check_circle_outline_rounded,
                        ),
                        label: Text(
                          task.completed ? 'Reopen Task' : 'Complete Task',
                        ),
                      );

                      if (constraints.maxWidth < 430) {
                        return Column(
                          children: [
                            SizedBox(width: double.infinity, child: viewResident),
                            const SizedBox(height: 10),
                            SizedBox(width: double.infinity, child: completeTask),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: viewResident),
                          const SizedBox(width: 12),
                          Expanded(child: completeTask),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openResident(BuildContext context) async {
    final resident = appState.residentById(task.residentId);
    if (resident == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resident profile could not be found.')),
      );
      return;
    }
    final discharged = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ResidentDetailScreen(
          appState: appState,
          resident: resident,
        ),
      ),
    );
    if (discharged == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _TaskRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TaskRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
