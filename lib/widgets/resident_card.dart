import 'package:flutter/material.dart';

import '../models/resident.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';

class ResidentCard extends StatelessWidget {
  final Resident resident;
  final VoidCallback onTap;

  const ResidentCard({
    super.key,
    required this.resident,
    required this.onTap,
  });

  String get _initials {
    final parts = resident.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'AC';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  Color get _statusColor {
    switch (resident.status) {
      case ResidentStatus.stable:
        return AppColors.green;
      case ResidentStatus.high:
        return AppColors.red;
      case ResidentStatus.review:
        return AppColors.orange;
      case ResidentStatus.low:
        return AppColors.cyan;
    }
  }

  String get _statusMeaning {
    switch (resident.status) {
      case ResidentStatus.stable:
        return 'stable';
      case ResidentStatus.high:
        return 'high priority';
      case ResidentStatus.review:
        return 'review';
      case ResidentStatus.low:
        return 'low priority';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;
    const radius = 26.0;

    return Semantics(
      button: true,
      label: '${resident.name}, $_statusMeaning, room ${resident.room}',
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
                  color: const Color(0xFF1D3557).withOpacity(0.045),
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
                      color: statusColor.withOpacity(0.38),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F6FC),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE5ECF4),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _initials,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resident.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.1,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Room ${resident.room}  •  ${resident.age} yrs',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ResidentStatusChip(status: resident.status),
                            const SizedBox(width: 2),
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
