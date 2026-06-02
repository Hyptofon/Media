import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/app_permission_status.dart';
import '../models/operation_result.dart';
import '../models/photo_source.dart';
import '../services/interfaces/i_permission_service.dart';
import '../services/interfaces/i_photo_repository.dart';

class GalleryController extends ChangeNotifier {
  final IPermissionService _permissions;
  final IPhotoRepository _repository;
  final ImagePicker _picker;

  GalleryController({
    required IPermissionService permissionService,
    required IPhotoRepository repository,
    ImagePicker? picker,
  }) : _permissions = permissionService,
       _repository = repository,
       _picker = picker ?? ImagePicker();

  IPermissionService get permissionService => _permissions;

  List<String> _photoIds = [];
  bool _isLoading = false;

  List<String> get imagePaths => List.unmodifiable(_photoIds);
  bool get isLoading => _isLoading;

  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);
  int get selectedCount => _selectedIds.length;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadPhotos() async {
    _setLoading(true);
    try {
      _photoIds = await _repository.loadPhotos();
    } finally {
      _setLoading(false);
    }
  }

  Future<PickResult> pickImage(PhotoSource source) async {
    final status = await _requestPermission(source);
    if (!status.isGranted) {
      return PickPermissionDenied(
        source: source,
        isPermanent: status.isPermanentlyDenied,
      );
    }

    _setLoading(true);
    try {
      final imageSource = switch (source) {
        PhotoSource.camera => ImageSource.camera,
        PhotoSource.gallery => ImageSource.gallery,
      };

      final XFile? xFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (xFile == null) return const PickCancelled();

      return PickRawFile(xFile: xFile);
    } on Exception catch (e) {
      return PickError(message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<SavePhotoResult> savePhoto(XFile xFile) async {
    _setLoading(true);
    try {
      final savedId = await _repository.addPhoto(xFile);
      _photoIds.add(savedId);
      notifyListeners();
      return SavePhotoSuccess(savedId: savedId);
    } on Exception catch (e) {
      return SavePhotoError(message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<DeleteResult> deletePhoto(int index) async {
    final photoId = _photoIds[index];
    try {
      await _repository.removePhoto(photoId);
      _photoIds.removeAt(index);
      _selectedIds.remove(photoId);
      notifyListeners();
      return const DeleteSuccess();
    } on Exception catch (e) {
      return DeleteError(message: e.toString());
    }
  }

  void enterSelectionMode(String photoId) {
    _isSelectionMode = true;
    _selectedIds.add(photoId);
    notifyListeners();
  }

  void toggleSelection(String photoId) {
    if (_selectedIds.contains(photoId)) {
      _selectedIds.remove(photoId);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    } else {
      _selectedIds.add(photoId);
    }
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    _selectedIds.clear();
    notifyListeners();
  }

  Future<BulkDeleteResult> deleteSelectedPhotos() async {
    final toDelete = List<String>.from(_selectedIds);
    int deleted = 0;
    int failed = 0;

    for (final photoId in toDelete) {
      try {
        await _repository.removePhoto(photoId);
        _photoIds.remove(photoId);
        _selectedIds.remove(photoId);
        deleted++;
      } on Exception {
        failed++;
      }
    }

    _isSelectionMode = _selectedIds.isNotEmpty;
    notifyListeners();

    if (failed == 0) {
      return BulkDeleteSuccess(deletedCount: deleted);
    }
    return BulkDeletePartial(deletedCount: deleted, failedCount: failed);
  }

  Future<AppPermissionStatus> _requestPermission(PhotoSource source) =>
      switch (source) {
        PhotoSource.camera => _permissions.requestCameraPermission(),
        PhotoSource.gallery => _permissions.requestGalleryPermission(),
      };
}
