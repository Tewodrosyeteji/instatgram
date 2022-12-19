import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/image_upload/constats/constants.dart';
import 'package:instatgram/state/image_upload/exceptions/could_not_build_thumbnali_exception.dart';
import 'package:instatgram/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instatgram/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instatgram/state/image_upload/models/file_type.dart';
import 'package:instatgram/state/image_upload/typedefs/is_loading.dart';
import 'package:instatgram/state/post_settings/models/post_setting.dart';
import 'package:instatgram/state/posts/models/post_payload.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<Isloading> {
  ImageUploadNotifier() : super(false);
  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required UserId userId,
    required Map<PostSetting, bool> postSetting,
  }) async {
    isLoading = true;
    late Uint8List thumbnailUnit8List;
    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUnit8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        final thub = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailQuality,
          quality: Constants.videoThumbnailQuality,
        );
        if (thub == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUnit8List = thub;
        }
        break;
    }
    final thumbnailAspectRatio = await thumbnailUnit8List.getAspectRatio();

    final fileName = const Uuid().v4();
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);
    try {
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUnit8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorgeId: originalFileStorageId,
        postSetting: postSetting,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
