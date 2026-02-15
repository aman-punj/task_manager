import 'package:intl/intl.dart';
import 'package:task_manager/core/app_config.dart';

class DateTimeHelper {
  static String format(DateTime dt) {
    final date = DateFormat('dd MMM yyyy').format(dt);
    final time = AppConfig.use24HourFormat
        ? DateFormat('HH:mm').format(dt)
        : DateFormat('hh:mm a').format(dt);

    return '$date • $time';
  }
}
