import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/models/filter_model.dart';

import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  bool isFilterApplied = false;

  TaskBloc(this.repository) : super(const TaskState()) {
    on<LoadTasks>(_load);
    on<AddTask>(_add);
    on<UpdateTask>(_update);
    on<DeleteTask>(_delete);
    on<FilterTasks>(_filter);
  }

  Future<void> _load(LoadTasks task, Emitter<TaskState> emit) async {
    final tasks = await repository.getTasks();

    isFilterApplied = false;
    emit(state.copyWith(tasks: tasks, filtered: tasks));
  }

  Future<void> _add(AddTask task, Emitter<TaskState> emit) async {
    await repository.addTask(task.task);
    add(LoadTasks());
  }

  Future<void> _update(UpdateTask event, Emitter<TaskState> emit) async {
    final updatedTask = event.task;
    await repository.updateTask(updatedTask);

    final updatedTasks = state.tasks.map((t) {
      return t.id == updatedTask.id ? updatedTask : t;
    }).toList();

    List<Task> updatedFiltered;

    if (isFilterApplied) {
      updatedFiltered = state.filtered
          .map((t) => t.id == updatedTask.id ? updatedTask : t)
          .where((t) {
        if (t.id != updatedTask.id) return true;

        if (updatedTask.isCompleted && !state.filtered.contains(updatedTask)) {
          return false;
        }

        return true;
      })
          .toList();
    } else {
      updatedFiltered = updatedTasks;
    }

    emit(state.copyWith(
      tasks: updatedTasks,
      filtered: updatedFiltered,
    ));
  }

  Future<void> _delete(DeleteTask task, Emitter<TaskState> emit) async {
    await repository.deleteTask(task.id);
    add(LoadTasks());
  }

  void _filter(FilterTasks event, Emitter<TaskState> emit) {
    final now = DateTime.now();
    final filter = event.filter;

    var result = state.tasks;

    if (filter.isCompleted != null) {
      result = result
          .where((task) => task.isCompleted == filter.isCompleted)
          .toList();
    }

    switch (filter.time) {
      case TaskTimeFilter.all:
        break;

      case TaskTimeFilter.today:
        result = result.where((task) {
          final d = task.dueDate;
          return d.year == now.year && d.month == now.month && d.day == now.day;
        }).toList();
        break;

      case TaskTimeFilter.overdue:
        result = result.where((task) {
          return !task.isCompleted && task.dueDate.isBefore(now);
        }).toList();
        break;

      case TaskTimeFilter.future:
        result = result.where((task) {
          return task.dueDate.isAfter(now);
        }).toList();
        break;
    }

    final isDefaultFilter =
        filter.isCompleted == null && filter.time == TaskTimeFilter.all;

    isFilterApplied = !isDefaultFilter;

    emit(state.copyWith(filtered: result));
  }
}
