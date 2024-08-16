class Task {
  final String id;
  final String title;
  final String description;
  final String state;
  final String priority;
  final String creator;
  final String note;
  final DateTime startDate;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.priority,
    required this.creator,
    required this.note,
    required this.startDate,
    required this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      state: json['state'] ?? '',
      priority: json['priority'] ?? '',
      creator: json['creator'] ?? '',
      note: json['note'] ?? '',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, state: $state, priority: $priority, creator: $creator, note: $note, startDate: $startDate, dueDate: $dueDate}';
  }
}
