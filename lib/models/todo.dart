class Todo {
  final String id;
  final String title;
  final DateTime deadline;
  late final bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.deadline,
    required this.isCompleted,
    required this.createdAt,
  });

  Todo copyWith({String? title, DateTime? deadline, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  bool get isOverdue => !isCompleted && deadline.isBefore(DateTime.now());
}
