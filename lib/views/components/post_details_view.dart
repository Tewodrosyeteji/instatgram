import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/enums/date_sorting.dart';
import 'package:instatgram/state/comments/models/post_comments_reqest.dart';
import 'package:instatgram/state/comments/models/post_with_comments.dart';
import 'package:instatgram/state/posts/models/post.dart';
import 'package:instatgram/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instatgram/state/posts/providers/delete_post_provider.dart';
import 'package:instatgram/state/posts/providers/specific_post_with_comment_provider.dart';
import 'package:instatgram/views/components/animations/error_animation_view.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/animations/small_error_animation_view.dart';
import 'package:instatgram/views/components/comment/comapact_comment_column.dart';
import 'package:instatgram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instatgram/views/components/dialogs/delete_dialog.dart';
import 'package:instatgram/views/components/like_button.dart';
import 'package:instatgram/views/components/likes_count_view.dart';
import 'package:instatgram/views/components/post/post_date_view.dart';
import 'package:instatgram/views/components/post/post_display_name_and_message_view.dart';
import 'package:instatgram/views/components/post/post_image_or_video_view.dart';
import 'package:instatgram/views/constants/strings.dart';
import 'package:instatgram/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    final postWithComment = ref.watch(
      specificPostWithCommentProvider(
        request,
      ),
    );

    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          postWithComment.when(
            data: ((postWithComments) {
              return IconButton(
                onPressed: (() {
                  final url = postWithComments.post.fileUrl;

                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                }),
                icon: const Icon(
                  Icons.share,
                ),
              );
            }),
            error: ((error, stackTrace) {
              return const SmallErrorAnimationView();
            }),
            loading: (() {
              return const LoadingAnimationView();
            }),
          ),
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: (() async {
                final shouldDeletePost = await DeleteDialog(
                  titleOfObjectTODelete: Strings.post,
                ).present(context).then(
                      (shouldDelete) => shouldDelete ?? false,
                    );

                if (shouldDeletePost) {
                  await ref.read(deletePostProvider.notifier).deletePost(
                        post: widget.post,
                      );

                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }),
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: postWithComment.when(
        data: ((postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (postWithComments.post.allowLikes)
                      LikeButton(
                        postId: postId,
                      ),
                    if (postWithComments.post.allowcomments)
                      IconButton(
                        onPressed: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                PostCommentsView(postId: postId)),
                          ));
                        }),
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                  ],
                ),
                PostDisplayNameAndMessageView(
                  post: postWithComments.post,
                ),
                PostDateView(
                  dateTime: postWithComments.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                CompactCommentColumn(
                  comments: postWithComments.comments,
                ),
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(
                          postId: postId,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 75,
                )
              ],
            ),
          );
        }),
        error: ((error, stackTrace) {
          return const ErrorAnimationView();
        }),
        loading: (() {
          return const LoadingAnimationView();
        }),
      ),
    );
  }
}
