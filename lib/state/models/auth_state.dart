import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/posts/typedef/user_id.dart';
import 'auth_result.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final UserId? userId;
  final bool isLoading;

  const AuthState({
    required this.result,
    required this.userId,
    required this.isLoading,
  });

  const AuthState.unKnown()
      : result = null,
        isLoading = false,
        userId = null;

  AuthState copyedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        userId: userId,
        isLoading: isLoading,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          userId == other.userId &&
          isLoading == other.isLoading);

  @override
  int get hashCode => Object.hash(isLoading, result, userId);
}
