import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../services/interfaces/i_photo_repository.dart';
import '../services/photo_file_service.dart';
import '../services/photo_preferences_service.dart';

class PhotoRepository implements IPhotoRepository {
  final PhotoFileService _fileService;
  final PhotoPreferencesService _prefsService;

  const PhotoRepository({
    required PhotoFileService fileService,
    required PhotoPreferencesService prefsService,
  }) : _fileService = fileService,
       _prefsService = prefsService;

  @override
  Future<List<String>> loadPhotos() => _prefsService.loadPaths();

  @override
  Future<String> addPhoto(XFile xFile) async {
    final newPath = await _fileService.savePhoto(File(xFile.path));
    final current = await _prefsService.loadPaths();
    await _prefsService.savePaths([...current, newPath]);
    return newPath;
  }

  @override
  Future<void> removePhoto(String photoId) async {
    await _fileService.deletePhoto(photoId);
    final current = await _prefsService.loadPaths();
    await _prefsService.savePaths(current.where((p) => p != photoId).toList());
  }
}
