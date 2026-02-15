import 'package:equatable/equatable.dart';
import 'package:task_manager/domain/models/filter_model.dart';

import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask(this.id);
}

class FilterTasks extends TaskEvent {
  final TaskFilter filter;

  FilterTasks(this.filter);
}
