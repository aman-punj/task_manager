import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final List<Task> filtered;

  const TaskState({this.tasks = const [], this.filtered = const []});

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? filtered,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filtered: filtered ?? this.filtered,
    );
  }

  @override
  List<Object?> get props => [tasks, filtered];
}
