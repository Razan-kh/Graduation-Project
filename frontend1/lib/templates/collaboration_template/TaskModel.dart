class Task {
  final String id;
  final String title;
  final String description;
  String status;  // We'll allow mutating status if needed
  final String priority;
  final DateTime startDate;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.dueDate,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Safely parse fields or provide defaults
    final String id = json['_id'] ?? '';
    final String title = json['title'] ?? 'Untitled Task';
    final String description = json['description'] ?? '';
    final String status = json['status'] ?? 'pending'; 
    final String priority = json['priority'] ?? 'low';

    // Attempt to parse dates, default to now if invalid or null
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    }

    final DateTime startDate = parseDate(json['startDate']);
    final DateTime dueDate = parseDate(json['dueDate']);

    return Task(
      id: id,
      title: title,
      description: description,
      status: status,
      startDate: startDate,
      dueDate: dueDate,
      priority: priority,
    );
  }
}
