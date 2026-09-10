import 'package:flutter/material.dart';

import '../models/resident.dart';
import '../theme/app_theme.dart';

class ResidentStatusChip extends StatelessWidget {
  final ResidentStatus status;

  const ResidentStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
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

  String get _label {
    switch (status) {
      case ResidentStatus.stable:
        return 'Stable';
      case ResidentStatus.high:
        return 'High';
      case ResidentStatus.review:
        return 'Review';
      case ResidentStatus.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _color.withOpacity(0.32), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.82),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
