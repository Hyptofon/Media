enum PhotoSource { camera, gallery }

extension PhotoSourceDisplay on PhotoSource {
  String get displayName => switch (this) {
    PhotoSource.camera => 'Camera',
    PhotoSource.gallery => 'Gallery',
  };
}
