class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
