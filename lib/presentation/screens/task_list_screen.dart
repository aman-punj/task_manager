import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/theme/app_scaffold.dart';
import 'package:task_manager/domain/models/filter_model.dart';

import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              final bloc = context.read<TaskBloc>();

              return PopupMenuButton<TaskFilter>(
                onSelected: (filter) => bloc.add(FilterTasks(filter)),
                icon: bloc.isFilterApplied
                    ? Icon(Icons.filter_list,
                        color: Theme.of(context).colorScheme.primary)
                    : const Icon(Icons.filter_list),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: TaskFilter(),
                    child: Text('All'),
                  ),
                  PopupMenuItem(
                    value: TaskFilter(isCompleted: true),
                    child: Text('Completed'),
                  ),
                  PopupMenuItem(
                    value: TaskFilter(isCompleted: false),
                    child: Text('Pending'),
                  ),
                  PopupMenuItem(
                    value: TaskFilter(time: TaskTimeFilter.overdue),
                    child: Text('Overdue'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.filtered.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          }

          return ListView.builder(
            itemCount: state.filtered.length,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 90,
            ),
            itemBuilder: (_, i) {
              final task = state.filtered[i];
              return TaskTile(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
