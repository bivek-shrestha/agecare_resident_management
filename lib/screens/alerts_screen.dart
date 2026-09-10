import 'package:flutter/material.dart';

import '../models/alert_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'resident_detail_screen.dart';

class AlertsScreen extends StatelessWidget {
  final AppState appState;

  const AlertsScreen({super.key, required this.appState});

  Color _color(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return AppColors.red;
      case AlertSeverity.medium:
        return AppColors.orange;
      case AlertSeverity.low:
        return AppColors.green;
    }
  }

  String _label(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.medium:
        return 'Review';
      case AlertSeverity.low:
        return 'Info';
    }
  }

  IconData _icon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return Icons.priority_high_rounded;
      case AlertSeverity.medium:
        return Icons.schedule_rounded;
      case AlertSeverity.low:
        return Icons.check_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          if (appState.alerts.isEmpty) {
            return const Center(
              child: Text(
                'No alerts',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: appState.alerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final alert = appState.alerts[index];
                  final color = _color(alert.severity);
                  const radius = 26.0;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(radius),
                      onTap: () {
                        final resident = appState.residentByName(alert.residentName);
                        if (resident == null) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ResidentDetailScreen(
                              appState: appState,
                              resident: resident,
                            ),
                          ),
                        );
                      },
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
                                  color: color.withOpacity(0.52),
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
                                            color: color.withOpacity(0.07),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _icon(alert.severity),
                                            color: color.withOpacity(0.82),
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
                                                alert.title,
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
                                                '${alert.residentName}  •  ${alert.time}',
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
                                              color: color.withOpacity(0.28),
                                            ),
                                          ),
                                          child: Text(
                                            _label(alert.severity),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: color,
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
