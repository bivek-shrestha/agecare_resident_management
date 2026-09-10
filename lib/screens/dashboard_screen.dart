import 'package:flutter/material.dart';

import '../models/alert_item.dart';
import '../models/care_task.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import 'alerts_screen.dart';
import 'residents_screen.dart';
import 'task_detail_screen.dart';
import 'tasks_screen.dart';

class DashboardScreen extends StatefulWidget {
  final AppState appState;
  final ValueChanged<String> onSearchResident;
  final ValueChanged<ResidentFilter> onOpenResidents;

  const DashboardScreen({
    super.key,
    required this.appState,
    required this.onSearchResident,
    required this.onOpenResidents,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    widget.onSearchResident(query);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final pendingTasks = widget.appState.tasks
            .where((task) => !task.completed)
            .take(3)
            .toList();
        final alerts = widget.appState.alerts.take(3).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(appState: widget.appState),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search resident by name, room or ID',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    tooltip: 'Search residents',
                    onPressed: _performSearch,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Resident Overview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => widget.onOpenResidents(ResidentFilter.all),
                    icon: const Icon(Icons.people_outline_rounded, size: 18),
                    label: const Text('View residents'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  return GridView.count(
                    crossAxisCount: wide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: wide ? 1.38 : 1.65,
                    children: [
                      StatCard(
                        label: 'Total Residents',
                        value: '${widget.appState.totalResidents}',
                        icon: Icons.people_alt_outlined,
                        accent: AppColors.primary,
                        onTap: () => widget.onOpenResidents(ResidentFilter.all),
                      ),
                      StatCard(
                        label: 'New Admission',
                        value: '${widget.appState.newAdmissions}',
                        icon: Icons.person_add_alt_1_rounded,
                        accent: AppColors.green,
                        onTap: () => widget.onOpenResidents(ResidentFilter.newAdmission),
                      ),
                      StatCard(
                        label: 'High Priority',
                        value: '${widget.appState.highPriority}',
                        icon: Icons.priority_high_rounded,
                        accent: AppColors.red,
                        onTap: () => widget.onOpenResidents(ResidentFilter.priority),
                      ),
                      StatCard(
                        label: 'Discharge',
                        value: '${widget.appState.discharges}',
                        icon: Icons.exit_to_app_rounded,
                        accent: AppColors.orange,
                        onTap: () => widget.onOpenResidents(ResidentFilter.discharge),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 22),
              SectionHeader(
                title: 'Today’s Tasks',
                icon: Icons.checklist_rounded,
                actionLabel: 'View All',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TasksScreen(appState: widget.appState),
                    ),
                  );
                },
              ),
              const SizedBox(height: 9),
              if (pendingTasks.isEmpty)
                const _EmptyCard(message: 'All care tasks are complete for now.')
              else
                ...pendingTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _TaskTile(
                      task: task,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(
                              appState: widget.appState,
                              task: task,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 13),
              SectionHeader(
                title: 'Alerts',
                icon: Icons.notifications_active_outlined,
                actionLabel: 'View All',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AlertsScreen(appState: widget.appState),
                    ),
                  );
                },
              ),
              const SizedBox(height: 9),
              ...alerts.map(
                (alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _AlertTile(alert: alert),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  final CareTask task;
  final VoidCallback onTap;

  const _TaskTile({required this.task, required this.onTap});

  Color get accent {
    switch (task.priority) {
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
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(Icons.schedule_rounded, color: accent, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(
                      '${task.residentName} • Due ${task.dueTime}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final AlertItem alert;

  const _AlertTile({required this.alert});

  Color get accent {
    switch (alert.severity) {
      case AlertSeverity.high:
        return AppColors.red;
      case AlertSeverity.medium:
        return AppColors.orange;
      case AlertSeverity.low:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.notifications_active_outlined, color: accent, size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(
                    '${alert.residentName} • ${alert.time}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}
