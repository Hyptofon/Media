import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PhotoFileService {
  const PhotoFileService();

  Future<String> savePhoto(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(path.join(appDir.path, 'photos'));

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final ext = path.extension(sourceFile.path).isNotEmpty
        ? path.extension(sourceFile.path)
        : '.jpg';
    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}$ext';
    final dest = path.join(photosDir.path, fileName);

    await sourceFile.copy(dest);
    return dest;
  }

  Future<void> deletePhoto(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
