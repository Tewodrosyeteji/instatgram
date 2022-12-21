import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/models/comment.dart';
import 'package:instatgram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/animations/small_error_animation_view.dart';
import 'package:instatgram/views/components/rich_two_parts_text.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;
  const CompactCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUserId,
      ),
    );
    return userInfo.when(data: ((userInfo) {
      return RichTwoPartstext(
        leftPart: userInfo.displayName,
        rightPart: comment.comment,
      );
    }), error: ((error, stackTrace) {
      return const SmallErrorAnimationView();
    }), loading: (() {
      return const LoadingAnimationView();
    }));
  }
}
