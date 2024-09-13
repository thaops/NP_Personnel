class Project {
  final String id;
  final String code;
  final String name;
  final String color;
  final String client;
  final String description;
  final String projectManager;
  final String projectManagerId;
  final DateTime startDate;
  final DateTime dueDate;
  final DateTime actualStartDate;
  final DateTime? finishDate;
  final String state;
  final String? linkDrive;

  Project({
    required this.id,
    required this.code,
    required this.name,
    required this.color,
    required this.client,
    required this.description,
    required this.projectManager,
    required this.projectManagerId,
    required this.startDate,
    required this.dueDate,
    required this.actualStartDate,
    this.finishDate,
    required this.state,
    this.linkDrive,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      color: json['color'],
      client: json['client'],
      description: json['description'],
      projectManager: json['projectManager'],
      projectManagerId: json['projectManagerId'],
      startDate: DateTime.parse(json['startDate']),
      dueDate: DateTime.parse(json['dueDate']),
      actualStartDate: DateTime.parse(json['actualStartDate']),
      finishDate: json['finishDate'] != null ? DateTime.parse(json['finishDate']) : null,
      state: json['state'],
      linkDrive: json['linkDrive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'color': color,
      'client': client,
      'description': description,
      'projectManager': projectManager,
      'projectManagerId': projectManagerId,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'actualStartDate': actualStartDate.toIso8601String(),
      'finishDate': finishDate?.toIso8601String(),
      'state': state,
      'linkDrive': linkDrive,
    };
  }

  @override
  String toString() {
    return 'Project(id: $id, code: $code, name: $name, color: $color, client: $client, description: $description, '
        'projectManager: $projectManager, projectManagerId: $projectManagerId, startDate: $startDate, '
        'dueDate: $dueDate, actualStartDate: $actualStartDate, finishDate: $finishDate, state: $state, '
        'linkDrive: $linkDrive, ';
  }
}
