import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/interfaces/i_photo_repository.dart';

class WebPhotoRepository implements IPhotoRepository {
  const WebPhotoRepository();

  static const _indexKey = 'image_paths';
  static const _dataKeyPrefix = 'photo_data_';

  static const int _maxDimension = 1024;
  static const double _jpegQuality = 0.75;

  @override
  Future<List<String>> loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList(_indexKey) ?? [];

    final existing = <String>[];
    for (final key in keys) {
      final data = prefs.getString('$_dataKeyPrefix$key');
      if (data != null) existing.add(key);
    }

    if (existing.length != keys.length) {
      await prefs.setStringList(_indexKey, existing);
    }

    final urls = <String>[];
    for (final key in existing) {
      final data = prefs.getString('$_dataKeyPrefix$key');
      if (data != null) urls.add(data);
    }
    return urls;
  }

  @override
  Future<String> addPhoto(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    final dataUrl = await _compressToDataUrl(bytes);

    final key = 'photo_${DateTime.now().millisecondsSinceEpoch}';
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('$_dataKeyPrefix$key', dataUrl);

    final keys = prefs.getStringList(_indexKey) ?? [];
    keys.add(key);
    await prefs.setStringList(_indexKey, keys);

    return dataUrl;
  }

  @override
  Future<void> removePhoto(String dataUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList(_indexKey) ?? [];

    String? foundKey;
    for (final key in keys) {
      if (prefs.getString('$_dataKeyPrefix$key') == dataUrl) {
        foundKey = key;
        break;
      }
    }

    if (foundKey != null) {
      await prefs.remove('$_dataKeyPrefix$foundKey');
      keys.remove(foundKey);
      await prefs.setStringList(_indexKey, keys);
    }
  }

  static Future<String> _compressToDataUrl(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'image/jpeg');
    final objectUrl = html.Url.createObjectUrlFromBlob(blob);

    final completer = Completer<html.ImageElement>();
    final img = html.ImageElement();

    img.onLoad.listen((_) => completer.complete(img));
    img.onError.listen((_) => completer.complete(img));
    img.src = objectUrl;

    final loadedImg = await completer.future;

    var w = loadedImg.naturalWidth;
    var h = loadedImg.naturalHeight;

    if (w == 0 || h == 0) {
      html.Url.revokeObjectUrl(objectUrl);
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }

    if (w > _maxDimension || h > _maxDimension) {
      if (w > h) {
        h = (h * _maxDimension / w).round();
        w = _maxDimension;
      } else {
        w = (w * _maxDimension / h).round();
        h = _maxDimension;
      }
    }

    final canvas = html.CanvasElement(width: w, height: h);
    canvas.context2D.drawImageScaled(loadedImg, 0, 0, w, h);

    html.Url.revokeObjectUrl(objectUrl);

    return canvas.toDataUrl('image/jpeg', _jpegQuality);
  }
}
