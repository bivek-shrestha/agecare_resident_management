import 'package:flutter/material.dart';

import '../models/resident.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';

class ResidentDetailScreen extends StatefulWidget {
  final AppState appState;
  final Resident resident;

  const ResidentDetailScreen({
    super.key,
    required this.appState,
    required this.resident,
  });

  @override
  State<ResidentDetailScreen> createState() => _ResidentDetailScreenState();
}

class _ResidentDetailScreenState extends State<ResidentDetailScreen> {
  late Resident _currentResident;

  @override
  void initState() {
    super.initState();
    _currentResident =
        widget.appState.residentById(widget.resident.id) ?? widget.resident;
  }

  String _date(DateTime value) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }

  Future<void> _editNotes() async {
    var draftNotes = _currentResident.notes;

    final updatedNotes = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Edit Notes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: SizedBox(
          width: 420,
          child: TextFormField(
            initialValue: draftNotes,
            autofocus: true,
            minLines: 4,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) => draftNotes = value,
            decoration: InputDecoration(
              hintText: 'Enter resident notes',
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, draftNotes.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (!mounted || updatedNotes == null) return;

    final cleanNotes = updatedNotes.trim();
    if (cleanNotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes cannot be empty.')),
      );
      return;
    }

    final updated = widget.appState.updateResidentNotes(
      _currentResident.id,
      cleanNotes,
    );
    if (!updated || !mounted) return;

    final refreshed = widget.appState.residentById(_currentResident.id);
    if (refreshed != null) {
      setState(() {
        _currentResident = refreshed;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes updated successfully.')),
    );
  }

  Future<void> _confirmDischarge() async {
    final shouldDischarge = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.07),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.logout_rounded,
            color: AppColors.red,
            size: 22,
          ),
        ),
        title: Text('Discharge ${_currentResident.name}?'),
        content: const Text(
          'This removes the resident from active care and clears their open tasks and alerts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discharge'),
          ),
        ],
      ),
    );

    if (!mounted || shouldDischarge != true) return;

    final name = _currentResident.name;
    final removed = widget.appState.dischargeResident(_currentResident.id);
    if (!removed || !mounted) return;

    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name discharged.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resident'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Medication'),
              Tab(text: 'Care Plan'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFE7EDF4)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D3557).withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 430;
                    final info = Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentResident.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Room ${_currentResident.room}  •  ${_currentResident.age} yrs',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              ResidentStatusChip(status: _currentResident.status),
                              if (compact) ...[
                                const Spacer(),
                                _DischargeButton(
                                  compact: true,
                                  onPressed: _confirmDischarge,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );

                    return Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F6FC),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5ECF4)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _currentResident.name
                                .split(' ')
                                .where((part) => part.isNotEmpty)
                                .take(2)
                                .map((part) => part[0])
                                .join()
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        info,
                        if (!compact) ...[
                          const SizedBox(width: 12),
                          _DischargeButton(
                            onPressed: _confirmDischarge,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(
                    resident: _currentResident,
                    dob: _date(_currentResident.dateOfBirth),
                    onEditNotes: _editNotes,
                  ),
                  _MedicationTab(resident: _currentResident),
                  _CarePlanTab(resident: _currentResident),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DischargeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool compact;

  const _DischargeButton({
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Discharge resident',
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFB4232B),
          backgroundColor: AppColors.red.withOpacity(0.045),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 11,
            vertical: 8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: BorderSide(color: AppColors.red.withOpacity(0.14)),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 15),
        label: Text(
          compact ? 'Discharge' : 'Discharge',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Resident resident;
  final String dob;
  final VoidCallback onEditNotes;

  const _OverviewTab({
    required this.resident,
    required this.dob,
    required this.onEditNotes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoCard(
          title: 'Personal Information',
          icon: Icons.person_outline_rounded,
          children: [
            _InfoRow(label: 'Date of birth', value: dob),
            _InfoRow(label: 'Gender', value: resident.gender),
            _InfoRow(label: 'Room', value: resident.room),
            _InfoRow(label: 'Care level', value: resident.careLevel),
            _InfoRow(label: 'Doctor', value: resident.doctor),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Medical Information',
          icon: Icons.medical_information_outlined,
          children: [
            _InfoRow(label: 'Conditions', value: resident.medicalConditions.join(', ')),
            _InfoRow(label: 'Allergies', value: resident.allergies.join(', ')),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Emergency Contact',
          icon: Icons.contact_emergency_outlined,
          children: [
            _InfoRow(label: 'Name', value: resident.emergencyContactName),
            _InfoRow(label: 'Phone', value: resident.emergencyContactPhone),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Notes',
          icon: Icons.notes_rounded,
          action: TextButton.icon(
            onPressed: onEditNotes,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 14),
            label: const Text(
              'Edit',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          children: [
            Text(
              resident.notes,
              style: const TextStyle(height: 1.45, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _MedicationTab extends StatelessWidget {
  final Resident resident;

  const _MedicationTab({required this.resident});

  @override
  Widget build(BuildContext context) {
    if (resident.medications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'No medication recorded yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              const Text(
                'Medication details can be added after the initial admission review.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: resident.medications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final medication = resident.medications[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medication_outlined, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        medication.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                    Text(
                      medication.dose,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(label: 'Schedule', value: medication.schedule),
                _InfoRow(label: 'Instructions', value: medication.instructions),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CarePlanTab extends StatelessWidget {
  final Resident resident;

  const _CarePlanTab({required this.resident});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoCard(
          title: 'Care Priorities',
          icon: Icons.favorite_outline_rounded,
          children: [
            const _PlanItem(
              title: 'Safety and mobility',
              description: 'Use the resident-specific mobility assistance noted by staff and record changes in ability.',
            ),
            const _PlanItem(
              title: 'Medication support',
              description: 'Check the medication schedule before administration and document completion.',
            ),
            _PlanItem(
              title: 'Current notes',
              description: resident.notes,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Care Team',
          icon: Icons.groups_2_outlined,
          children: [
            _InfoRow(label: 'Primary doctor', value: resident.doctor),
            const _InfoRow(label: 'Care team', value: 'Registered nurse and assigned care workers'),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? action;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanItem extends StatelessWidget {
  final String title;
  final String description;

  const _PlanItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 20, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
