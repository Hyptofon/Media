import '../../models/app_permission_status.dart';

abstract interface class IPermissionService {
  Future<AppPermissionStatus> requestCameraPermission();

  Future<AppPermissionStatus> requestGalleryPermission();

  Future<void> openSettings();
}
