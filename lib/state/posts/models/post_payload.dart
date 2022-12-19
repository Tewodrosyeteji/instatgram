import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/image_upload/models/file_type.dart';
import 'package:instatgram/state/post_settings/models/post_setting.dart';
import 'package:instatgram/state/posts/models/post_keys.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';

@immutable
class PostPayload extends MapView<String, dynamic> {
  PostPayload({
    required UserId userId,
    required String message,
    required String thumbnailUrl,
    required String fileUrl,
    required FileType fileType,
    required String fileName,
    required double aspectRatio,
    required String thumbnailStorageId,
    required String originalFileStorgeId,
    required Map<PostSetting, bool> postSetting,
  }) : super({
          PostKeys.userId: userId,
          PostKeys.message: message,
          PostKeys.createdAt: FieldValue.serverTimestamp(),
          PostKeys.thumbnailUrl: thumbnailUrl,
          PostKeys.fileUrl: fileUrl,
          PostKeys.fileType: fileType.name,
          PostKeys.aspectRatio: aspectRatio,
          PostKeys.thumbnailStorageId: thumbnailStorageId,
          PostKeys.originalFileStorageId: originalFileStorgeId,
          PostKeys.postSetting: {
            for (final postSet in postSetting.entries)
              postSet.key.storageKey: postSet.value,
          }
        });
}
