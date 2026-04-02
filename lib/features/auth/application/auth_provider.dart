import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// 認証されていない場合の一時的なユーザーID
const kLocalUserId = 'local_user';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

@riverpod
String currentUid(Ref ref) {
  // 認証情報の取得を試みる。取得できない場合はローカル用IDを返す。
  final user = ref.watch(authStateProvider).value;
  return user?.uid ?? kLocalUserId;
}

/// 現在のユーザーが匿名アカウント（未本会員登録）かどうか
@riverpod
bool isAnonymousUser(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  // ユーザーが存在しないか、匿名の場合はtrue
  return user == null || user.isAnonymous;
}
