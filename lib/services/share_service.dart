import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  Future<void> sharePhoto(String photoId) async {
    if (kIsWeb) {
      final comma = photoId.indexOf(',');
      if (comma == -1) return;

      final bytes = base64Decode(photoId.substring(comma + 1));
      final xFile = XFile.fromData(
        bytes,
        mimeType: 'image/jpeg',
        name: 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      try {
        await Share.shareXFiles([xFile], text: 'Check out this photo!');
      } catch (_) {
        final anchor = html.AnchorElement(href: photoId)
          ..target = 'blank'
          ..download = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();
      }
    } else {
      await Share.shareXFiles([XFile(photoId)], text: 'Check out this photo!');
    }
  }
}
