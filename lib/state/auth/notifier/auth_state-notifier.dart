import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/posts/typedef/user_id.dart';
import 'package:instatgram/state/models/auth_result.dart';
import 'package:instatgram/state/user_info/models/backend/user_info_storage.dart';

import '../../backend/authenticator.dart';
import '../../models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unKnown()) {
    if (_authenticator.isAlearedyLogged) {
      state = AuthState(
        result: AuthResult.sucess,
        userId: _authenticator.userId,
        isLoading: false,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copyedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unKnown();
  }

  Future<void> logInWithGoogle() async {
    state = state.copyedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.sucess && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      userId: userId,
      isLoading: false,
    );
  }

  Future<void> logInWithFacebook() async {
    state = state.copyedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;
    if (result == AuthResult.sucess && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      userId: userId,
      isLoading: false,
    );
  }

  Future<void> saveUserInfo({
    required UserId userId,
  }) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        email: _authenticator.email,
        displayName: _authenticator.displayName ?? '',
      );
}
