import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/core/utils/app_snack_bar.dart';
import 'package:task_manager/presentation/screens/add_edit_task_screen.dart';

import '../../core/utils/date_time_helper.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();
    final theme = Theme.of(context);
    final date = DateTimeHelper.format(task.dueDate);

    final now = DateTime.now();
    final diff = task.dueDate.difference(now);

    Color indicatorColor;

    if (task.isCompleted) {
      indicatorColor = Colors.green;
    } else if (task.dueDate.isBefore(now)) {
      indicatorColor = Colors.red;
    } else if (diff.inMinutes <= 30) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = theme.colorScheme.primary;
    }

    final isOverdue = !task.isCompleted && task.dueDate.isBefore(now);
    final isDueSoon = !task.isCompleted && !isOverdue && diff.inMinutes <= 30;

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              bloc.add(DeleteTask(task.id!));
              AppSnackBar.show(context, message: "Task deleted",status: SnackStatus.success);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTaskScreen(task: task),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 50,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isOverdue ? Colors.red : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due • $date',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    if (isOverdue)
                      Text(
                        'Overdue',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.red),
                      )
                    else if (isDueSoon)
                      Text(
                        'Due soon',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: Colors.orange),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Checkbox(
                value: task.isCompleted,
                onChanged: (v) {
                  bloc.add(UpdateTask(task.copyWith(isCompleted: v)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
