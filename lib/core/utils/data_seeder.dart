

import 'dart:math';
import '../../domain/entities/task.dart';

class DataSeeder {
  static final _rand = Random();

  static List<Task> generate({int count = 100}) {
    final now = DateTime.now();
    final List<Task> tasks = [];

    for (int i = 0; i < count; i++) {
      final offsetDays = _rand.nextInt(20) - 10; // -10 to +10 days
      final randomHour = _rand.nextInt(24);
      final randomMinute = _rand.nextInt(60);

      final date = DateTime(
        now.year,
        now.month,
        now.day + offsetDays,
        randomHour,
        randomMinute,
      );

      final completed = date.isBefore(now)
          ? _rand.nextBool() // past tasks may be done
          : _rand.nextInt(4) == 0; // fewer future completed

      tasks.add(Task(
        title: _randomTitle(),
        description: _randomDescription(),
        dueDate: date,
        isCompleted: completed,
      ));
    }

    return tasks;
  }

  // -------- Fake Content --------

  static String _randomTitle() {
    const titles = [
      'Team meeting',
      'Doctor appointment',
      'Gym session',
      'Submit report',
      'Call client',
      'Study Flutter',
      'Grocery shopping',
      'Pay bills',
      'Code review',
      'Plan trip',
      'Meditation',
      'Fix bugs',
      'Write journal',
      'Read book',
    ];
    return titles[_rand.nextInt(titles.length)];
  }

  static String _randomDescription() {
    const desc = [
      'Don’t forget important details',
      'Prepare notes in advance',
      'Focus on productivity',
      'Keep it short and clear',
      'Important for future goals',
      'Stay consistent',
      'Follow up required',
      'Check dependencies',
      'Be on time',
      'Optional but helpful',
    ];
    return desc[_rand.nextInt(desc.length)];
  }
}
