import 'package:flutter/material.dart';

import '../models/photo_source.dart';
import 'source_tile.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final ValueChanged<PhotoSource> onSourceSelected;

  const ImageSourceBottomSheet({super.key, required this.onSourceSelected});

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<PhotoSource> onSourceSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          ImageSourceBottomSheet(onSourceSelected: onSourceSelected),
    );
  }

  void _select(BuildContext context, PhotoSource source) {
    Navigator.of(context).pop();
    onSourceSelected(source);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _BottomSheetHandle(),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'Add Photo',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SourceTile(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              iconColor: colorScheme.primary,
              onTap: () => _select(context, PhotoSource.camera),
            ),
            SourceTile(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              iconColor: colorScheme.tertiary,
              onTap: () => _select(context, PhotoSource.gallery),
            ),
            SourceTile(
              icon: Icons.cancel_outlined,
              label: 'Cancel',
              iconColor: colorScheme.error,
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
