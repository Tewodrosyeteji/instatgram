import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/image_upload/notifiers/image_upload_notifer.dart';
import 'package:instatgram/state/image_upload/typedefs/is_loading.dart';

final imageUplaoderProvider =
    StateNotifierProvider<ImageUploadNotifier, Isloading>(
  ((ref) => ImageUploadNotifier()),
);
