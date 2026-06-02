import 'package:flutter/material.dart';

import '../screens/photo_detail_screen.dart';

abstract final class AppNavigator {
  static Future<void> pushPhotoDetail({
    required BuildContext context,
    required String photoId,
    required int index,
    required VoidCallback onDelete,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PhotoDetailScreen(
          photoId: photoId,
          index: index,
          onDelete: onDelete,
        ),
      ),
    );
  }
}
