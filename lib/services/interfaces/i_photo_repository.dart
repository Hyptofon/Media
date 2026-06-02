import 'package:image_picker/image_picker.dart';

abstract interface class IPhotoRepository {
  Future<List<String>> loadPhotos();

  Future<String> addPhoto(XFile xFile);

  Future<void> removePhoto(String photoId);
}
