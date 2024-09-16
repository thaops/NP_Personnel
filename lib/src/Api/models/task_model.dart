class Task {
  final String id;
  final String title;
  final String description;
  final String state;
  final String priority;
  final String creator;
  final String note;
  final String project;
  final DateTime startDate;
  final DateTime dueDate;
  final String projectId;
  final String sprintId;
  final String sprintTitle;
  final String creatorId;
  final String assignee;  // Assignee added here

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.priority,
    required this.creator,
    required this.note,
    required this.project,
    required this.startDate,
    required this.dueDate,
    required this.projectId,
    required this.sprintId,
    required this.sprintTitle,
    required this.creatorId,
    required this.assignee,  // Added in constructor
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
      project: json['project'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      projectId: json['projectId'] ?? '',
      sprintId: json['sprintId'] ?? '',
      sprintTitle: json['sprintTitle'] ?? '',
      creatorId: json['creatorId'] ?? '',
      assignee: json['assignee'] ?? '', 
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, state: $state, priority: $priority, creator: $creator, note: $note, project: $project, startDate: $startDate, dueDate: $dueDate, projectId: $projectId, sprintId: $sprintId, sprintTitle: $sprintTitle, creatorId: $creatorId, assignee: $assignee}';
  }
}
