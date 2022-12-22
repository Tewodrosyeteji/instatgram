import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/auth_state_provider.dart';
import 'package:instatgram/state/comments/providers/delete_comment_provider.dart';
import 'package:instatgram/state/comments/providers/send_comment_provider.dart';
import 'package:instatgram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instatgram/state/posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider<bool>(
  ((ref) {
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUplaoderProvider);
    final isSendingCommet = ref.watch(sendCommentProvider);
    final isDeletingCommet = ref.watch(deleteCommentProvider);
    final isDeletingPost = ref.watch(deletePostProvider);

    return authState.isLoading ||
        isUploadingImage ||
        isSendingCommet ||
        isDeletingCommet ||
        isDeletingPost;
  }),
);
