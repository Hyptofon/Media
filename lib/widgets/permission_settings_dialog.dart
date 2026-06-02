import 'package:flutter/material.dart';

class PermissionSettingsDialog extends StatelessWidget {
  final String permissionName;
  final VoidCallback onOpenSettings;

  const PermissionSettingsDialog({
    super.key,
    required this.permissionName,
    required this.onOpenSettings,
  });

  static Future<void> show({
    required BuildContext context,
    required String permissionName,
    required VoidCallback onOpenSettings,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => PermissionSettingsDialog(
        permissionName: permissionName,
        onOpenSettings: onOpenSettings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.settings_outlined),
      title: Text('$permissionName Permission'),
      content: Text(
        '$permissionName access is permanently denied. '
        'Enable it in your device Settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onOpenSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
