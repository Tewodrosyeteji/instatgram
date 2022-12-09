import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/posts/models/post_keys.dart';
import 'package:instatgram/state/image_upload/models/file_type.dart';
import 'package:instatgram/state/post_settings/models/post_setting.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final DateTime createdAt;
  final String message;
  final FileType fileType;
  final String fileName;
  final String fileUrl;
  final String originalFileStorageId;
  final String thumbnailUrl;
  final String thumbnailStorageId;
  final double aspectRatio;
  final Map<PostSetting, bool> postSettings;

  Post({required this.postId, required Map<String, dynamic> json})
      : userId = json[PostKeys.userId],
        createdAt = (json[PostKeys.createdAt] as Timestamp).toDate(),
        message = json[PostKeys.message],
        fileName = json[PostKeys.fileName],
        fileUrl = json[PostKeys.fileUrl],
        originalFileStorageId = json[PostKeys.originalFileStorageId],
        thumbnailUrl = json[PostKeys.thumbnailUrl],
        thumbnailStorageId = json[PostKeys.thumbnailStorageId],
        aspectRatio = json[PostKeys.aspectRatio],
        fileType = FileType.values.firstWhere(
          (fileType) => fileType == json[PostKeys.fileType],
          orElse: () => FileType.image,
        ),
        postSettings = {
          for (final entry in json[PostKeys.postSetting].entries)
            PostSetting.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };

  bool get allowLikes => postSettings[PostSetting.allowLikes] ?? false;
  bool get allowcomments => postSettings[PostSetting.allowComments] ?? false;
}
