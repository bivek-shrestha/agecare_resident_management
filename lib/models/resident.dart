enum ResidentStatus { stable, high, review, low }

class Medication {
  final String name;
  final String dose;
  final String schedule;
  final String instructions;

  const Medication({
    required this.name,
    required this.dose,
    required this.schedule,
    required this.instructions,
  });
}

class Resident {
  final String id;
  final String name;
  final String room;
  final DateTime dateOfBirth;
  final String gender;
  final String careLevel;
  final String doctor;
  final ResidentStatus status;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<Medication> medications;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String notes;
  final bool isNewAdmission;
  final bool dischargePlanned;

  const Resident({
    required this.id,
    required this.name,
    required this.room,
    required this.dateOfBirth,
    required this.gender,
    required this.careLevel,
    required this.doctor,
    required this.status,
    required this.medicalConditions,
    required this.allergies,
    required this.medications,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.notes,
    this.isNewAdmission = false,
    this.dischargePlanned = false,
  });

  int get age {
    final now = DateTime.now();
    var years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }
}
