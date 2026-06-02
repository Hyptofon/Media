import '../models/app_permission_status.dart';
import 'interfaces/i_permission_service.dart';

class WebPermissionService implements IPermissionService {
  const WebPermissionService();

  @override
  Future<AppPermissionStatus> requestCameraPermission() async =>
      AppPermissionStatus.granted;

  @override
  Future<AppPermissionStatus> requestGalleryPermission() async =>
      AppPermissionStatus.granted;

  @override
  Future<void> openSettings() async {}
}
