import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<List<Task>> getTasks() => datasource.getTasks();

  @override
  Future<void> addTask(Task task) {
    return datasource.insertTask(TaskModel(
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    ));
  }

  @override
  Future<void> updateTask(Task task) {
    return datasource.updateTask(TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    ));
  }

  @override
  Future<void> deleteTask(int id) => datasource.deleteTask(id);
}
