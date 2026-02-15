import '../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.isCompleted,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map[AppConstants.colId],
      title: map[AppConstants.colTitle],
      description: map[AppConstants.colDescription],
      dueDate: DateTime.parse(map[AppConstants.colDueDate]),
      isCompleted: map[AppConstants.colCompleted] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.colId: id,
      AppConstants.colTitle: title,
      AppConstants.colDescription: description,
      AppConstants.colDueDate: dueDate.toIso8601String(),
      AppConstants.colCompleted: isCompleted ? 1 : 0,
    };
  }
}
