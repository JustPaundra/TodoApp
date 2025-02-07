class Todo {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;
  DateTime deadline;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    required this.deadline,
  });

  Duration? get completionTime {
    if (completedAt != null) {
      return completedAt!.difference(createdAt);
    }
    return null;
  }

  bool get isOverdue {
    if (!isCompleted && DateTime.now().isAfter(deadline)) {
      return true;
    }
    return false;
  }
}