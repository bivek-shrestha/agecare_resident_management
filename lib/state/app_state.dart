import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/alert_item.dart';
import '../models/care_task.dart';
import '../models/message.dart';
import '../models/resident.dart';

class AppState extends ChangeNotifier {
  final List<Resident> _residents = List<Resident>.from(mockResidents);
  final List<CareTask> _tasks = List<CareTask>.from(mockTasks);
  final List<AlertItem> _alerts = List<AlertItem>.from(mockAlerts);
  final List<ChatThread> _threads = List<ChatThread>.from(mockThreads);

  List<Resident> get residents => List.unmodifiable(_residents);
  List<CareTask> get tasks => List.unmodifiable(_tasks);
  List<AlertItem> get alerts => List.unmodifiable(_alerts);
  List<ChatThread> get threads => List.unmodifiable(_threads);

  int get totalResidents => _residents.length;
  int get newAdmissions => _residents.where((r) => r.isNewAdmission).length;
  int get highPriority => _residents.where((r) => r.status == ResidentStatus.high).length;
  int get discharges => _residents.where((r) => r.dischargePlanned).length;
  int get pendingTasks => _tasks.where((task) => !task.completed).length;

  Resident? residentById(String id) {
    for (final resident in _residents) {
      if (resident.id == id) return resident;
    }
    return null;
  }

  Resident? residentByName(String name) {
    for (final resident in _residents) {
      if (resident.name.toLowerCase() == name.toLowerCase()) return resident;
    }
    return null;
  }

  void addResident(Resident resident) {
    _residents.insert(0, resident);
    notifyListeners();
  }

  bool dischargeResident(String residentId) {
    Resident? resident;
    for (final item in _residents) {
      if (item.id == residentId) {
        resident = item;
        break;
      }
    }
    if (resident == null) return false;

    _residents.removeWhere((item) => item.id == residentId);
    _tasks.removeWhere((task) => task.residentId == residentId);
    _alerts.removeWhere(
      (alert) => alert.residentName.toLowerCase() == resident!.name.toLowerCase(),
    );
    notifyListeners();
    return true;
  }

  void setTaskCompleted(String taskId, bool completed) {
    for (final task in _tasks) {
      if (task.id == taskId) {
        task.completed = completed;
        notifyListeners();
        return;
      }
    }
  }
}
