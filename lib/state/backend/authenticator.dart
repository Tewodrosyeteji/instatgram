import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instatgram/posts/typedef/user_id.dart';

import '../auth/constants/constants.dart';
import '../models/auth_result.dart';

class Authenticator {
  const Authenticator();
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlearedyLogged => userId != null;
  String? get displayName => FirebaseAuth.instance.currentUser?.displayName;
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;
    if (token == null) {
      return AuthResult.aborted;
    }

    final authCredentialProvider = FacebookAuthProvider.credential(token);

    try {
      await FirebaseAuth.instance.signInWithCredential(authCredentialProvider);
      return AuthResult.sucess;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;

      if (e.code == Constants.accountExistsWithDifferentCredential &&
          email != null &&
          credential != null) {
        final providers =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if (providers.contains(Constants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.sucess;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      Constants.emailScope,
    ]);

    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final googleCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(googleCredential);
      return AuthResult.sucess;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
