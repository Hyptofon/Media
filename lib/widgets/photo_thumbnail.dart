import 'package:flutter/material.dart';

import 'photo_image.dart';

class PhotoThumbnail extends StatelessWidget {
  final String photoId;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const PhotoThumbnail({
    super.key,
    required this.photoId,
    required this.heroTag,
    required this.onTap,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: PhotoImage(photoId: photoId, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
