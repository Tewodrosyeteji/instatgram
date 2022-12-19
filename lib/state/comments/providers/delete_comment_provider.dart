import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:instatgram/state/image_upload/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentStateNotifier, Isloading>(
  ((_) => DeleteCommentStateNotifier()),
);
