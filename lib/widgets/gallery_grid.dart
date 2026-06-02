import 'package:flutter/material.dart';

import 'photo_thumbnail.dart';

class GalleryGrid extends StatelessWidget {
  final List<String> imagePaths;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final void Function(int index) onPhotoTap;
  final void Function(int index) onPhotoDelete;
  final void Function(String photoId) onPhotoLongPress;
  final void Function(String photoId) onPhotoSelect;

  const GalleryGrid({
    super.key,
    required this.imagePaths,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.onPhotoTap,
    required this.onPhotoDelete,
    required this.onPhotoLongPress,
    required this.onPhotoSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (_, index) {
        final photoId = imagePaths[index];
        final isSelected = selectedIds.contains(photoId);

        if (isSelectionMode) {
          return _SelectableTile(
            key: ValueKey(photoId),
            photoId: photoId,
            isSelected: isSelected,
            index: index,
            onSelect: () => onPhotoSelect(photoId),
          );
        }

        return _DismissibleThumbnail(
          key: ValueKey(photoId),
          photoId: photoId,
          index: index,
          onTap: () => onPhotoTap(index),
          onDelete: () => onPhotoDelete(index),
          onLongPress: () => onPhotoLongPress(photoId),
        );
      },
    );
  }
}

class _DismissibleThumbnail extends StatelessWidget {
  final String photoId;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const _DismissibleThumbnail({
    super.key,
    required this.photoId,
    required this.index,
    required this.onTap,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(photoId),
      direction: DismissDirection.up,
      onDismissed: (_) => onDelete(),
      background: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ColoredBox(
          color: colorScheme.errorContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.onErrorContainer,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                'Delete',
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
      child: PhotoThumbnail(
        photoId: photoId,
        heroTag: 'photo_$index',
        onTap: onTap,
        onDelete: onDelete,
        onLongPress: onLongPress,
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final String photoId;
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;

  const _SelectableTile({
    super.key,
    required this.photoId,
    required this.index,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedOpacity(
              opacity: isSelected ? 0.65 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Hero(
                tag: 'photo_$index',
                child: PhotoThumbnail(
                  photoId: photoId,
                  heroTag: 'photo_sel_$index',
                  onTap: onSelect,
                  onDelete: () {},
                  onLongPress: () {},
                ),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surface.withAlpha(200),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
