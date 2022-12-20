import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/notifiers/send_comment_notifier.dart';
import 'package:instatgram/state/image_upload/typedefs/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, Isloading>(
  ((_) => SendCommentNotifier()),
);
