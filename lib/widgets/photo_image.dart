import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoImage extends StatelessWidget {
  final String photoId;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const PhotoImage({
    super.key,
    required this.photoId,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  Widget _fallback(BuildContext ctx) => ColoredBox(
    color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.broken_image_outlined),
  );

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      try {
        final comma = photoId.indexOf(',');
        final bytes = base64Decode(photoId.substring(comma + 1));
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: errorBuilder ?? (ctx, err, stack) => _fallback(ctx),
        );
      } catch (_) {
        return _fallback(context);
      }
    }

    return Image.file(
      io.File(photoId),
      fit: fit,
      errorBuilder: errorBuilder ?? (ctx, err, stack) => _fallback(ctx),
    );
  }
}
