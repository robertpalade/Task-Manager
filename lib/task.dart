class Task {
  String? id;
  String title;
  String userId;

  Task({
    this.id,
    required this.title,
    required this.userId,
  });

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        userId = map['userId'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
    };
  }
}
