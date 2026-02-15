class TaskFilter {
  final bool? isCompleted; // null = all
  final TaskTimeFilter time;

  const TaskFilter({
    this.isCompleted,
    this.time = TaskTimeFilter.all,
  });
}

enum TaskTimeFilter {
  all,
  today,
  overdue,
  future,
}
