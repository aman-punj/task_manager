import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/app_snack_bar.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_scaffold.dart';
import '../../core/utils/date_time_helper.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({this.task, super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();

  late final ValueNotifier<DateTime> _dateTime;
  late final ValueNotifier<bool> _done;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final defaultTime = DateTime(now.year, now.month, now.day, 8);

    final task = widget.task;

    _dateTime = ValueNotifier(task?.dueDate ?? defaultTime);
    _done = ValueNotifier(task?.isCompleted ?? false);

    if (task != null) {
      _title.text = task.title;
      _desc.text = task.description;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _dateTime.dispose();
    _done.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;

    return AppScaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Task' : 'New Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _title,
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: context.textTheme.titleMedium,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _desc,
                    maxLines: 3,
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Due Date'),
              subtitle: ValueListenableBuilder<DateTime>(
                valueListenable: _dateTime,
                builder: (_, value, __) {
                  return Text(
                    DateTimeHelper.format(value),
                    style: context.textTheme.bodyMedium,
                  );
                },
              ),
              trailing: TextButton(
                onPressed: _pickDateTime,
                child: const Text('Change'),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ValueListenableBuilder<bool>(
              valueListenable: _done,
              builder: (_, value, __) {
                return SwitchListTile(
                  value: value,
                  title: const Text('Mark as completed'),
                  secondary: const Icon(Icons.check_circle_outline),
                  onChanged: (v) => _done.value = v,
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          FilledButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Task'),
            onPressed: _save,
          ),
        ],
      ),
    );
  }


  Future<void> _pickDateTime() async {
    final current = _dateTime.value;

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: current.isBefore(DateTime.now()) ? DateTime.now() : current,
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (combined.isBefore(DateTime.now())) {
      _showError('Cannot create task in the past');
      return;
    }

    _dateTime.value = combined;
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      _showError('Title required');
      return;
    }

    final due = _dateTime.value;

    if (due.isBefore(DateTime.now())) {
      _showError('Task cannot be in past');
      return;
    }

    final bloc = context.read<TaskBloc>();

    final task = Task(
      id: widget.task?.id,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      dueDate: due,
      isCompleted: _done.value,
    );

    if (widget.task == null) {
      bloc.add(AddTask(task));
      AppSnackBar.show(
        context,
        message: 'Task created',
        status: SnackStatus.success,
      );
    } else {
      bloc.add(UpdateTask(task));
      AppSnackBar.show(
        context,
        message: 'Task updated',
        status: SnackStatus.success,
      );
    }

    Navigator.pop(context);
  }

  void _showError(String msg) {
    AppSnackBar.show(
      context,
      message: msg,
      status: SnackStatus.error,
    );
  }
}
