import 'package:flutter/material.dart';

import '../widgets/photo_viewer.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String photoId;
  final int index;
  final VoidCallback onDelete;

  const PhotoDetailScreen({
    super.key,
    required this.photoId,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoViewer(
      photoId: photoId,
      heroTag: 'photo_$index',
      onDelete: onDelete,
    );
  }
}
