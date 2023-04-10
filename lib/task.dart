class Task {
  String? id;
  String title;
  String userId;
  String? description;
  bool isChecked;
  DateTime? date;

  Task({
    this.id,
    required this.title,
    required this.userId,
    this.description = '',
    this.isChecked = false,
    this.date,
  });

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        userId = map['userId'],
        description = map['description'],
        isChecked = map['isChecked'],
        date = DateTime.parse(map['date']);
        // priority = map['priority'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'description': description,
      'isChecked': isChecked,
      'date': date?.toIso8601String(),
      // 'priority': priority,
    };
  }
}
