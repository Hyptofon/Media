import 'package:image_picker/image_picker.dart';

import '../models/photo_source.dart';

sealed class PickResult {
  const PickResult();
}

final class PickRawFile extends PickResult {
  final XFile xFile;

  const PickRawFile({required this.xFile});
}

final class PickCancelled extends PickResult {
  const PickCancelled();
}

final class PickPermissionDenied extends PickResult {
  final PhotoSource source;
  final bool isPermanent;

  const PickPermissionDenied({required this.source, required this.isPermanent});
}

final class PickError extends PickResult {
  final String message;

  const PickError({required this.message});
}

sealed class SavePhotoResult {
  const SavePhotoResult();
}

final class SavePhotoSuccess extends SavePhotoResult {
  final String savedId;

  const SavePhotoSuccess({required this.savedId});
}

final class SavePhotoError extends SavePhotoResult {
  final String message;

  const SavePhotoError({required this.message});
}

sealed class DeleteResult {
  const DeleteResult();
}

final class DeleteSuccess extends DeleteResult {
  const DeleteSuccess();
}

final class DeleteError extends DeleteResult {
  final String message;

  const DeleteError({required this.message});
}

sealed class BulkDeleteResult {
  const BulkDeleteResult();
}

final class BulkDeleteSuccess extends BulkDeleteResult {
  final int deletedCount;

  const BulkDeleteSuccess({required this.deletedCount});
}

final class BulkDeletePartial extends BulkDeleteResult {
  final int deletedCount;
  final int failedCount;

  const BulkDeletePartial({
    required this.deletedCount,
    required this.failedCount,
  });
}
