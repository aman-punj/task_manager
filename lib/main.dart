import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/theme/app_theme.dart';

import 'data/datasources/local/task_local_datasource.dart';
import 'data/repositories/task_repository_impl.dart';
import 'presentation/blocs/task/task_bloc.dart';
import 'presentation/blocs/task/task_event.dart';
import 'presentation/screens/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TaskRepositoryImpl(TaskLocalDatasource()),
      child: BlocProvider(
        create: (context) =>
            TaskBloc(context.read<TaskRepositoryImpl>())..add(LoadTasks()),
        child: MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          home: const TaskListScreen(),
        ),
      ),
    );
  }
}
