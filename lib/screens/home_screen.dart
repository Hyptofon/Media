import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/gallery_controller.dart';
import '../models/operation_result.dart';
import '../models/photo_source.dart';
import '../navigation/app_navigator.dart';
import '../repositories/photo_repository.dart';
import '../services/cropper_service.dart';
import '../services/permission_service.dart';
import '../services/photo_file_service.dart';
import '../services/photo_preferences_service.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/gallery_app_bar.dart';
import '../widgets/gallery_empty_state.dart';
import '../widgets/gallery_grid.dart';
import '../widgets/gallery_loading_indicator.dart';
import '../widgets/image_source_bottom_sheet.dart';
import '../widgets/permission_settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  final GalleryController controller;
  final CropperService cropperService;

  HomeScreen({super.key})
    : controller = GalleryController(
        permissionService: const PermissionService(),
        repository: PhotoRepository(
          fileService: const PhotoFileService(),
          prefsService: const PhotoPreferencesService(),
        ),
      ),
      cropperService = const CropperService();

  const HomeScreen.withController({
    super.key,
    required this.controller,
    this.cropperService = const CropperService(),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GalleryController get _ctrl => widget.controller;
  CropperService get _cropper => widget.cropperService;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onControllerUpdate);
    _ctrl.loadPhotos();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerUpdate);
    _ctrl.dispose();
    super.dispose();
  }

  void _onControllerUpdate() => setState(() {});

  Future<void> _onPickImage(PhotoSource source) async {
    final result = await _ctrl.pickImage(source);
    if (!mounted) return;

    switch (result) {
      case PickRawFile(:final xFile):
        await _cropAndSave(xFile);
      case PickCancelled():
        break;
      case PickPermissionDenied(:final source, :final isPermanent):
        if (isPermanent) {
          PermissionSettingsDialog.show(
            context: context,
            permissionName: source.displayName,
            onOpenSettings: _ctrl.permissionService.openSettings,
          );
        } else {
          AppSnackBar.show(context, '${source.displayName} permission denied');
        }
      case PickError(:final message):
        AppSnackBar.show(context, 'Error: $message');
    }
  }

  Future<void> _cropAndSave(XFile rawFile) async {
    XFile? cropped;
    try {
      cropped = await _cropper.cropImage(
        context: context,
        source: rawFile,
      );
    } catch (_) {
      cropped = null;
    }
    if (!mounted) return;

    final toSave = cropped ?? rawFile;
    final saveResult = await _ctrl.savePhoto(toSave);
    if (!mounted) return;

    switch (saveResult) {
      case SavePhotoSuccess():
        AppSnackBar.show(context, 'Photo saved! 📸');
      case SavePhotoError(:final message):
        AppSnackBar.show(context, 'Error saving: $message');
    }
  }

  Future<void> _onDeletePhoto(int index) async {
    final result = await _ctrl.deletePhoto(index);
    if (!mounted) return;

    switch (result) {
      case DeleteSuccess():
        AppSnackBar.show(context, 'Photo deleted');
      case DeleteError(:final message):
        AppSnackBar.show(context, 'Error deleting: $message');
    }
  }

  void _onLongPress(String photoId) => _ctrl.enterSelectionMode(photoId);

  void _onSelectPhoto(String photoId) => _ctrl.toggleSelection(photoId);

  void _onCancelSelection() => _ctrl.exitSelectionMode();

  Future<void> _onDeleteSelected() async {
    final count = _ctrl.selectedCount;

    DeleteConfirmationDialog.show(
      context: context,
      title: 'Delete $count photo${count == 1 ? '' : 's'}',
      message: 'Remove $count selected photo${count == 1 ? '' : 's'}?',
      onConfirm: _doBulkDelete,
    );
  }

  Future<void> _doBulkDelete() async {
    final result = await _ctrl.deleteSelectedPhotos();
    if (!mounted) return;

    switch (result) {
      case BulkDeleteSuccess(:final deletedCount):
        AppSnackBar.show(
          context,
          '$deletedCount photo${deletedCount == 1 ? '' : 's'} deleted',
        );
      case BulkDeletePartial(:final deletedCount, :final failedCount):
        AppSnackBar.show(context, '$deletedCount deleted, $failedCount failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final paths = _ctrl.imagePaths;

    return Scaffold(
      appBar: GalleryAppBar(
        photoCount: paths.length,
        isSelectionMode: _ctrl.isSelectionMode,
        selectedCount: _ctrl.selectedCount,
        onAddPhoto: () => ImageSourceBottomSheet.show(
          context: context,
          onSourceSelected: _onPickImage,
        ),
        onDeleteSelected: _onDeleteSelected,
        onCancelSelection: _onCancelSelection,
      ),
      body: switch (_ctrl.isLoading) {
        true => const GalleryLoadingIndicator(),
        false when paths.isEmpty => GalleryEmptyState(
          onAddPhoto: () => ImageSourceBottomSheet.show(
            context: context,
            onSourceSelected: _onPickImage,
          ),
        ),
        _ => GalleryGrid(
          imagePaths: paths,
          isSelectionMode: _ctrl.isSelectionMode,
          selectedIds: _ctrl.selectedIds,
          onPhotoTap: (index) => AppNavigator.pushPhotoDetail(
            context: context,
            photoId: paths[index],
            index: index,
            onDelete: () => _onDeletePhoto(index),
          ),
          onPhotoDelete: _onDeletePhoto,
          onPhotoLongPress: _onLongPress,
          onPhotoSelect: _onSelectPhoto,
        ),
      },
    );
  }
}
