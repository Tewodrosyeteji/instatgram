import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/user_info/models/user_info_payload.dart';
import '../../../../posts/typedef/user_id.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String? email,
    required String displayName,
  }) async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFiledName, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFiledName.email: email ?? '',
          FirebaseFiledName.displayName: displayName
        });
        return true;
      }

      final payload = UserInfoPayload(
          userId: userId, email: email, displayName: displayName);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
