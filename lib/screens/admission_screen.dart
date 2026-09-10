import 'package:flutter/material.dart';

import '../models/resident.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AdmissionScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onFinished;

  const AdmissionScreen({
    super.key,
    required this.appState,
    required this.onFinished,
  });

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  final _doctorController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  int _step = 0;
  int? _editingStep;
  DateTime? _dob;
  String _gender = 'Female';
  String _careLevel = 'Standard Care';

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _doctorController.dispose();
    _conditionsController.dispose();
    _allergiesController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectDob() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: _dob ?? DateTime(1940),
    );
    if (result != null) {
      setState(() => _dob = result);
    }
  }

  bool _validateCurrentStep() {
    if (_step == 0) {
      final valid = _formKeys[0].currentState?.validate() ?? false;
      if (_dob == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select the resident’s date of birth.'),
          ),
        );
        return false;
      }
      return valid;
    }
    if (_step == 1) {
      return _formKeys[1].currentState?.validate() ?? false;
    }
    if (_step == 2) {
      return _formKeys[2].currentState?.validate() ?? false;
    }
    return true;
  }

  void _next() {
    if (!_validateCurrentStep()) return;
    if (_editingStep != null) {
      setState(() {
        _step = 3;
        _editingStep = null;
      });
      return;
    }
    if (_step < 3) {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() {
        _step--;
        if (_editingStep != null && _step != _editingStep) {
          _editingStep = null;
        }
      });
    }
  }

  void _editStep(int step) {
    setState(() {
      _step = step;
      _editingStep = step;
    });
  }

  void _jumpToCompletedStep(int step) {
    if (step > _step && _step != 3) return;
    if (_step == 3 && step < 3) {
      _editStep(step);
      return;
    }
    if (step <= _step) {
      setState(() {
        _step = step;
        _editingStep = null;
      });
    }
  }

  void _saveResident() {
    final id = 'AC-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final conditions = _splitList(_conditionsController.text);
    final allergies = _splitList(_allergiesController.text);

    final resident = Resident(
      id: id,
      name: _nameController.text.trim(),
      room: _roomController.text.trim(),
      dateOfBirth: _dob!,
      gender: _gender,
      careLevel: _careLevel,
      doctor: _doctorController.text.trim(),
      status: ResidentStatus.review,
      medicalConditions:
          conditions.isEmpty ? const ['No condition recorded'] : conditions,
      allergies: allergies.isEmpty ? const ['None recorded'] : allergies,
      medications: const [],
      emergencyContactName: _contactNameController.text.trim(),
      emergencyContactPhone: _contactPhoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? 'New admission. Initial care notes pending.'
          : _notesController.text.trim(),
      isNewAdmission: true,
    );

    widget.appState.addResident(resident);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 42,
              color: AppColors.green,
            ),
          ),
          title: const Text('Admission successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${resident.name} has been added to AgeCare.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _SuccessRow(label: 'Resident ID', value: resident.id),
              _SuccessRow(label: 'Room', value: resident.room),
              _SuccessRow(label: 'Care level', value: resident.careLevel),
            ],
          ),
          actions: [
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
                widget.onFinished();
              },
              icon: const Icon(Icons.people_alt_rounded),
              label: const Text('View Residents'),
            ),
          ],
        );
      },
    );
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _resetForm() {
    _nameController.clear();
    _roomController.clear();
    _doctorController.clear();
    _conditionsController.clear();
    _allergiesController.clear();
    _contactNameController.clear();
    _contactPhoneController.clear();
    _notesController.clear();
    setState(() {
      _step = 0;
      _editingStep = null;
      _dob = null;
      _gender = 'Female';
      _careLevel = 'Standard Care';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New resident admission',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Complete the required details, review them, then save the admission.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _ProgressHeader(
                step: _step,
                onStepTap: _jumpToCompletedStep,
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _stepBody(),
                ),
              ),
              const SizedBox(height: 22),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final editing = _editingStep != null && _step < 3;
    return Row(
      children: [
        if (_step > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ),
        if (_step > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: _step == 3 ? _saveResident : _next,
            icon: Icon(
              _step == 3
                  ? Icons.check_circle_outline_rounded
                  : editing
                      ? Icons.fact_check_outlined
                      : Icons.arrow_forward_rounded,
            ),
            label: Text(
              _step == 3
                  ? 'SAVE RESIDENT'
                  : editing
                      ? 'Save changes & review'
                      : 'Continue',
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepBody() {
    switch (_step) {
      case 0:
        return Form(
          key: _formKeys[0],
          child: _FormCard(
            title: 'Personal Information',
            subtitle: 'Basic identity details for the resident profile.',
            icon: Icons.person_outline_rounded,
            children: [
              _LabeledField(
                label: 'Full Name *',
                controller: _nameController,
                hint: 'e.g. Laxmi Shrestha',
                validator: _required,
              ),
              const SizedBox(height: 14),
              const Text(
                'Date of Birth *',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
              const SizedBox(height: 7),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _selectDob,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  child: Text(
                    _dob == null ? 'Select date' : _dateText(_dob!),
                    style: TextStyle(
                      color: _dob == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
              const SizedBox(height: 7),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.wc_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                  DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _gender = value ?? _gender),
              ),
            ],
          ),
        );
      case 1:
        return Form(
          key: _formKeys[1],
          child: _FormCard(
            title: 'Care Information',
            subtitle: 'Placement, clinical information and care requirements.',
            icon: Icons.health_and_safety_outlined,
            children: [
              _LabeledField(
                label: 'Room Assignment *',
                controller: _roomController,
                hint: 'e.g. A-101',
                validator: _required,
              ),
              const SizedBox(height: 14),
              const Text(
                'Care Level *',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
              const SizedBox(height: 7),
              DropdownButtonFormField<String>(
                value: _careLevel,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.favorite_outline_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'Low Care', child: Text('Low Care')),
                  DropdownMenuItem(
                    value: 'Standard Care',
                    child: Text('Standard Care'),
                  ),
                  DropdownMenuItem(value: 'High Care', child: Text('High Care')),
                  DropdownMenuItem(
                    value: 'Memory Support',
                    child: Text('Memory Support'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _careLevel = value ?? _careLevel),
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Doctor’s Name *',
                controller: _doctorController,
                hint: 'e.g. Dr Sarah Patel',
                validator: _required,
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Medical Condition',
                controller: _conditionsController,
                hint: 'Separate multiple conditions with commas',
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Allergies',
                controller: _allergiesController,
                hint: 'e.g. Penicillin, latex',
              ),
            ],
          ),
        );
      case 2:
        return Form(
          key: _formKeys[2],
          child: _FormCard(
            title: 'Emergency Contact',
            subtitle: 'Who staff should contact for the resident when needed.',
            icon: Icons.contact_emergency_outlined,
            children: [
              _LabeledField(
                label: 'Contact Name *',
                controller: _contactNameController,
                hint: 'Full name',
                validator: _required,
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Contact Phone *',
                controller: _contactPhoneController,
                hint: 'Phone number',
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Initial Notes',
                controller: _notesController,
                hint: 'Mobility, communication or care notes',
                maxLines: 4,
              ),
            ],
          ),
        );
      case 3:
      default:
        return _buildReview();
    }
  }

  Widget _buildReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.16)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.fact_check_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Final review: check each section below. Use Edit to return directly to that page, update the details, and come back to review.',
                  style: TextStyle(
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'Personal Information',
          icon: Icons.person_outline_rounded,
          onEdit: () => _editStep(0),
          rows: [
            _ReviewValue(label: 'Full Name', value: _nameController.text),
            _ReviewValue(
              label: 'Date of Birth',
              value: _dob == null ? '-' : _dateText(_dob!),
            ),
            _ReviewValue(label: 'Gender', value: _gender),
          ],
        ),
        const SizedBox(height: 12),
        _ReviewSection(
          title: 'Care Information',
          icon: Icons.health_and_safety_outlined,
          onEdit: () => _editStep(1),
          rows: [
            _ReviewValue(label: 'Room', value: _roomController.text),
            _ReviewValue(label: 'Care Level', value: _careLevel),
            _ReviewValue(label: 'Doctor', value: _doctorController.text),
            _ReviewValue(
              label: 'Conditions',
              value: _conditionsController.text.isEmpty
                  ? 'None recorded'
                  : _conditionsController.text,
            ),
            _ReviewValue(
              label: 'Allergies',
              value: _allergiesController.text.isEmpty
                  ? 'None recorded'
                  : _allergiesController.text,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ReviewSection(
          title: 'Emergency Contact & Notes',
          icon: Icons.contact_emergency_outlined,
          onEdit: () => _editStep(2),
          rows: [
            _ReviewValue(
              label: 'Contact',
              value: _contactNameController.text,
            ),
            _ReviewValue(
              label: 'Phone',
              value: _contactPhoneController.text,
            ),
            _ReviewValue(
              label: 'Notes',
              value: _notesController.text.isEmpty
                  ? 'No initial notes added'
                  : _notesController.text,
            ),
          ],
        ),
      ],
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }
}

class _ProgressHeader extends StatelessWidget {
  final int step;
  final ValueChanged<int> onStepTap;

  const _ProgressHeader({
    required this.step,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Personal', 'Care', 'Contact', 'Review'];
    return Row(
      children: List.generate(4, (index) {
        final active = index <= step;
        final tappable = index <= step || step == 3;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: tappable ? () => onStepTap(index) : null,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : const Color(0xFFE5EBF3),
                            shape: BoxShape.circle,
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.18),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: index < step
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: Colors.white,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: active
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight:
                                active ? FontWeight.w800 : FontWeight.w600,
                            color: active
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (index < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: index < step
                          ? AppColors.primary
                          : const Color(0xFFE5EBF3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _FormCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final List<_ReviewValue> rows;

  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 19, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const Divider(height: 24),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _ReviewValue extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              value.trim().isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  final String label;
  final String value;

  const _SuccessRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
