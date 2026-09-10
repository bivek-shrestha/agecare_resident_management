import 'package:flutter/material.dart';

import '../models/alert_item.dart';
import '../models/care_task.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'resident_detail_screen.dart';
import 'task_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final AppState appState;

  const NotificationsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          final notifications = <_NotificationItem>[
            ...appState.alerts.take(4).map(
                  (alert) => _NotificationItem(
                    title: alert.title,
                    subtitle: '${alert.residentName}  •  ${alert.time}',
                    icon: Icons.notifications_none_rounded,
                    typeLabel: _alertTypeLabel(alert.severity),
                    color: _alertColor(alert.severity),
                    target: 'alert:${alert.residentName}',
                  ),
                ),
            ...appState.tasks.where((task) => !task.completed).take(4).map(
                  (task) => _NotificationItem(
                    title: task.title,
                    subtitle: '${task.residentName}  •  ${task.dueTime}',
                    icon: Icons.checklist_rounded,
                    typeLabel: _taskTypeLabel(task.priority),
                    color: _taskColor(task.priority),
                    target: 'task:${task.id}',
                  ),
                ),
          ];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: notifications.isEmpty
                  ? const _EmptyNotifications()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        return _NotificationCard(
                          item: item,
                          onTap: () => _openNotification(context, item.target),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  static Color _alertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return AppColors.red;
      case AlertSeverity.medium:
        return AppColors.orange;
      case AlertSeverity.low:
        return AppColors.green;
    }
  }

  static String _alertTypeLabel(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.medium:
        return 'Review';
      case AlertSeverity.low:
        return 'Info';
    }
  }

  static Color _taskColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.red;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.low:
        return AppColors.cyan;
    }
  }

  static String _taskTypeLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Urgent';
      case TaskPriority.medium:
        return 'Task';
      case TaskPriority.low:
        return 'Routine';
    }
  }

  void _openNotification(BuildContext context, String target) {
    if (target.startsWith('task:')) {
      final id = target.substring('task:'.length);
      for (final task in appState.tasks) {
        if (task.id == id) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TaskDetailScreen(appState: appState, task: task),
            ),
          );
          return;
        }
      }
      return;
    }

    if (target.startsWith('alert:')) {
      final name = target.substring('alert:'.length);
      final resident = appState.residentByName(name);
      if (resident != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResidentDetailScreen(
              appState: appState,
              resident: resident,
            ),
          ),
        );
      }
    }
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String typeLabel;
  final Color color;
  final String target;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.typeLabel,
    required this.color,
    required this.target,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const radius = 26.0;

    return Semantics(
      button: true,
      label: '${item.typeLabel}: ${item.title}. ${item.subtitle}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: const Color(0xFFE7EDF4)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D3557).withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      color: item.color.withOpacity(0.52),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.07),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.icon,
                                color: item.color.withOpacity(0.82),
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.1,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: item.color.withOpacity(0.28),
                                ),
                              ),
                              child: Text(
                                item.typeLabel,
                                style: TextStyle(
                                  color: item.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xFFB4BFCC),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 34,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 10),
          Text(
            'All clear',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
