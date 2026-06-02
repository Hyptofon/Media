import 'package:flutter/material.dart';

import '../services/share_service.dart';
import 'delete_confirmation_dialog.dart';
import 'photo_image.dart';

class PhotoViewer extends StatelessWidget {
  final String photoId;
  final String heroTag;
  final VoidCallback onDelete;

  const PhotoViewer({
    super.key,
    required this.photoId,
    required this.heroTag,
    required this.onDelete,
  });

  void _requestDelete(BuildContext context) {
    DeleteConfirmationDialog.show(
      context: context,
      title: 'Delete Photo',
      message: 'Are you sure you want to delete this photo?',
      onConfirm: () {
        Navigator.of(context).pop();
        onDelete();
      },
    );
  }

  Future<void> _sharePhoto(BuildContext context) async {
    try {
      await const ShareService().sharePhoto(photoId);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not share: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.shadow,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorScheme.shadow.withAlpha(153),
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onInverseSurface),
        actions: [
          IconButton(
            tooltip: 'Share photo',
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _sharePhoto(context),
          ),
          IconButton(
            tooltip: 'Delete photo',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _requestDelete(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: PhotoImage(photoId: photoId, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
