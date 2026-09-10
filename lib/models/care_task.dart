enum TaskPriority { high, medium, low }

class CareTask {
  final String id;
  final String title;
  final String residentId;
  final String residentName;
  final String dueTime;
  final String assignedTo;
  final String instructions;
  final TaskPriority priority;
  bool completed;

  CareTask({
    required this.id,
    required this.title,
    required this.residentId,
    required this.residentName,
    required this.dueTime,
    required this.assignedTo,
    required this.instructions,
    required this.priority,
    this.completed = false,
  });
}
