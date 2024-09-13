
class Sprint {
  String code;
  String title;
  String description;
  String project;
  String projectId;
  DateTime startDate;
  DateTime endDate;
  String state;
  String id;
  DateTime createdDate;
  DateTime updatedDate;
  String creatorId;
  String creator;
  String modifierId;
  String modifier;
  bool isDeleted;

  Sprint({
    required this.code,
    required this.title,
    required this.description,
    required this.project,
    required this.projectId,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.creatorId,
    required this.creator,
    required this.modifierId,
    required this.modifier,
    required this.isDeleted,
  });

  factory Sprint.fromJson(Map<String, dynamic> json) {
    return Sprint(
      code: json['code'],
      title: json['title'],
      description: json['description'] ?? '',
      project: json['project'],
      projectId: json['projectId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      state: json['state'] ?? '',
      id: json['id'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      creatorId: json['creatorId'],
      creator: json['creator'],
      modifierId: json['modifierId'],
      modifier: json['modifier'],
      isDeleted: json['isDeleted'],
    );
  }

  @override
  String toString() {
    return 'Sprint(code: $code, title: $title, description: $description, project: $project, projectId: $projectId, startDate: $startDate, endDate: $endDate, state: $state, id: $id, createdDate: $createdDate, updatedDate: $updatedDate, creatorId: $creatorId, creator: $creator, modifierId: $modifierId, modifier: $modifier, isDeleted: $isDeleted)';
  }
}
