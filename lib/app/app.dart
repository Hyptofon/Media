import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../controllers/gallery_controller.dart';
import '../repositories/photo_repository.dart';
import '../repositories/web_photo_repository.dart';
import '../screens/home_screen.dart';
import '../services/cropper_service.dart';
import '../services/permission_service.dart';
import '../services/photo_file_service.dart';
import '../services/photo_preferences_service.dart';
import '../services/web_permission_service.dart';
import '../theme/app_theme.dart';

class PhotoGalleryApp extends StatelessWidget {
  const PhotoGalleryApp({super.key});

  GalleryController _buildController() {
    if (kIsWeb) {
      return GalleryController(
        permissionService: const WebPermissionService(),
        repository: const WebPhotoRepository(),
      );
    }
    return GalleryController(
      permissionService: const PermissionService(),
      repository: PhotoRepository(
        fileService: const PhotoFileService(),
        prefsService: const PhotoPreferencesService(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: HomeScreen.withController(
        controller: _buildController(),
        cropperService: const CropperService(),
      ),
    );
  }
}
