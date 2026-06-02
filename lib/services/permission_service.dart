import 'package:permission_handler/permission_handler.dart';

import '../models/app_permission_status.dart';
import 'interfaces/i_permission_service.dart';

class PermissionService implements IPermissionService {
  const PermissionService();

  @override
  Future<AppPermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return AppPermissionStatus.granted;
    }
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return _map(result);
    }
    if (status.isPermanentlyDenied) {
      return AppPermissionStatus.permanentlyDenied;
    }
    return _map(status);
  }

  @override
  Future<AppPermissionStatus> requestGalleryPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) {
      return AppPermissionStatus.granted;
    }
    if (status.isDenied) {
      final result = await Permission.photos.request();
      if (result.isLimited) {
        return AppPermissionStatus.granted;
      }
      return _map(result);
    }
    if (status.isPermanentlyDenied) {
      return AppPermissionStatus.permanentlyDenied;
    }
    return _map(status);
  }

  @override
  Future<void> openSettings() async => openAppSettings();

  static AppPermissionStatus _map(PermissionStatus s) {
    if (s.isGranted || s.isLimited) return AppPermissionStatus.granted;
    if (s.isPermanentlyDenied) return AppPermissionStatus.permanentlyDenied;
    return AppPermissionStatus.denied;
  }
}
