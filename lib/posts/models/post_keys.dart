import 'package:flutter/foundation.dart' show immutable;

@immutable
class PostKeys {
  static const userId = 'uid';
  static const message = 'message';
  static const createdAt = 'created_at';
  static const fileType = 'file_type';
  static const fileName = 'file_name';
  static const fileUrl = 'file_url';
  static const originalFileStorageId = 'original_file_storage_id';
  static const thumbnailUrl = 'thumbnail_url';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const postSetting = 'post_setting';
  static const aspectRatio = 'aspect_ratio';

  const PostKeys._();
}
