import 'package:flutter/material.dart';

enum SnackStatus { success, error, pending }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackStatus status = SnackStatus.success,
  }) {
    final theme = Theme.of(context);

    final config = _SnackConfig.fromStatus(status, theme);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: config.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      content: Row(
        children: [
          Icon(config.icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}


class _SnackConfig {
  final Color backgroundColor;
  final IconData icon;

  const _SnackConfig({
    required this.backgroundColor,
    required this.icon,
  });

  factory _SnackConfig.fromStatus(
    SnackStatus status,
    ThemeData theme,
  ) {
    switch (status) {
      case SnackStatus.success:
        return const _SnackConfig(
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      case SnackStatus.error:
        return const _SnackConfig(
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      case SnackStatus.pending:
        return const _SnackConfig(
          backgroundColor: Colors.orange,
          icon: Icons.schedule,
        );
    }
  }
}
