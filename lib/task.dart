class Task {
  String? id;
  String title;
  String userId;
  String? description;

  Task({
    this.id,
    required this.title,
    required this.userId,
    this.description,
  });

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        userId = map['userId'],
        description = map['description'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'description': description,
    };
  }
}
