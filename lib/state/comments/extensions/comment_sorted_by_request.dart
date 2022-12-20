import 'package:instatgram/enums/date_sorting.dart';
import 'package:instatgram/state/comments/models/comment.dart';
import 'package:instatgram/state/comments/models/post_comments_reqest.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocument = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldestOnTop:
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );
      return sortedDocument;
    } else {
      return this;
    }
  }
}
