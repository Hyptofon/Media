import 'package:flutter/material.dart';

class GalleryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int photoCount;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onAddPhoto;
  final VoidCallback onDeleteSelected;
  final VoidCallback onCancelSelection;

  const GalleryAppBar({
    super.key,
    required this.photoCount,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onAddPhoto,
    required this.onDeleteSelected,
    required this.onCancelSelection,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isSelectionMode) {
      return _SelectionAppBar(
        selectedCount: selectedCount,
        onDelete: onDeleteSelected,
        onCancel: onCancelSelection,
      );
    }

    return _NormalAppBar(photoCount: photoCount, onAddPhoto: onAddPhoto);
  }
}

class _NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int photoCount;
  final VoidCallback onAddPhoto;

  const _NormalAppBar({required this.photoCount, required this.onAddPhoto});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Photos'),
      actions: [
        if (photoCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _PhotoCountChip(count: photoCount),
          ),
        IconButton(
          tooltip: 'Add photo',
          icon: const Icon(Icons.add_a_photo_rounded),
          onPressed: onAddPhoto,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const _SelectionAppBar({
    required this.selectedCount,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.primaryContainer,
      leading: IconButton(
        tooltip: 'Cancel selection',
        icon: const Icon(Icons.close_rounded),
        onPressed: onCancel,
      ),
      title: Text(
        '$selectedCount selected',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Delete selected',
          icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
          onPressed: selectedCount > 0 ? onDelete : null,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _PhotoCountChip extends StatelessWidget {
  final int count;

  const _PhotoCountChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.photo_outlined, size: 16),
      label: Text(
        '$count',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
