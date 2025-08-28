class Task {
  final String id;
  final String userId; // new field
  final String title;
  bool isCompleted;
  String details;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.isCompleted = false,
    this.details = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // save userId
      'title': title,
      'isCompleted': isCompleted,
      'details': details,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      isCompleted: map['isCompleted'],
      details: map['details'] ?? '',
    );
  }
}
