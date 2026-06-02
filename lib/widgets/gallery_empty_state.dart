import 'package:flutter/material.dart';

class GalleryEmptyState extends StatelessWidget {
  final VoidCallback onAddPhoto;

  const GalleryEmptyState({super.key, required this.onAddPhoto});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GradientCircleIcon(colorScheme: colorScheme),
            const SizedBox(height: 24),
            Text(
              'No Photos Yet',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the camera button to add your first photo',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onAddPhoto,
              icon: const Icon(Icons.add_a_photo_rounded),
              label: const Text('Add Photo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientCircleIcon extends StatelessWidget {
  final ColorScheme colorScheme;

  const _GradientCircleIcon({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.photo_library_outlined,
        size: 64,
        color: colorScheme.primary,
      ),
    );
  }
}
