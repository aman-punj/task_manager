import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/task_model.dart';

class TaskLocalDatasource {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

// for dev=test purpose
  Future<void> insertBulk(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();

    for (final t in tasks) {
      batch.insert('tasks', t.toMap());
    }

    await batch.commit(noResult: true);
  }


  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);

    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: (db, _) async {
        await db.execute('''
        CREATE TABLE ${AppConstants.taskTable}(
          ${AppConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${AppConstants.colTitle} TEXT,
          ${AppConstants.colDescription} TEXT,
          ${AppConstants.colDueDate} TEXT,
          ${AppConstants.colCompleted} INTEGER
        )
        ''');
      },
    );
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(AppConstants.taskTable);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(AppConstants.taskTable, task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      AppConstants.taskTable,
      task.toMap(),
      where: '${AppConstants.colId} = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      AppConstants.taskTable,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
