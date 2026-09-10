enum AlertSeverity { high, medium, low }

class AlertItem {
  final String id;
  final String title;
  final String message;
  final String residentName;
  final String time;
  final AlertSeverity severity;

  const AlertItem({
    required this.id,
    required this.title,
    required this.message,
    required this.residentName,
    required this.time,
    required this.severity,
  });
}
