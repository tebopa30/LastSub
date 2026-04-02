import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_provider.dart';
import '../../../core/providers/repository_providers.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  /// アプリ起動時に呼び出す匿名サインイン処理
  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(firebaseAuthProvider);
      // 既にサインイン済みの場合は何もしない
      if (auth.currentUser != null) return;
      
      final userCredential = await auth.signInAnonymously();
      
      if (userCredential.user != null) {
        await _backupLocalDataToFirestore(userCredential.user!.uid);
      }
    });
  }

  /// Google Sign-In を行い、匿名アカウントならリンク（データ引き継ぎ）、
  /// 非匿名アカウントがあれば直接サインインする。
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final auth = ref.read(firebaseAuthProvider);
      debugPrint('[Auth][Google] ① 開始 — 現在UID: ${auth.currentUser?.uid}');

      final googleSignIn = GoogleSignIn();
      debugPrint('[Auth][Google] ② GoogleSignIn.signIn() 呼び出し（ダイアログ表示待ち）');
      final googleUser = await googleSignIn.signIn();
      if (!ref.mounted) return;
      if (googleUser == null) {
        debugPrint('[Auth][Google] ② キャンセル検出 — state を AsyncData に戻す');
        state = const AsyncData(null);
        return;
      }
      debugPrint('[Auth][Google] ③ アカウント選択完了: ${googleUser.email}');

      debugPrint('[Auth][Google] ④ authentication トークン取得中...');
      final googleAuth = await googleUser.authentication;
      if (!ref.mounted) return;
      debugPrint('[Auth][Google] ④ accessToken: ${googleAuth.accessToken != null ? "取得済み" : "null"}, '
          'idToken: ${googleAuth.idToken != null ? "取得済み" : "null"}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('[Auth][Google] ⑤ Firebase credential 生成完了');

      final currentUser = auth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        debugPrint('[Auth][Google] ⑥ 匿名→Googleリンク試行: uid=${currentUser.uid}');
        try {
          await currentUser.linkWithCredential(credential);
          if (!ref.mounted) return;
          debugPrint('[Auth][Google] ⑥ linkWithCredential 成功');
        } on FirebaseAuthException catch (e) {
          debugPrint('[Auth][Google] ⑥ linkWithCredential エラー: code=${e.code} message=${e.message}');
          if (e.code == 'credential-already-in-use' ||
              e.code == 'account-exists-with-different-credential' ||
              e.code == 'email-already-in-use') {
            debugPrint('[Auth][Google] ⑦ 既存アカウントへ signInWithCredential (code=${e.code})');
            await auth.signInWithCredential(credential);
            if (!ref.mounted) return;
            debugPrint('[Auth][Google] ⑦ signInWithCredential 成功');
          } else {
            // raw FirebaseAuthException をそのまま rethrow して _friendlyAuthError で処理
            rethrow;
          }
        }
      } else {
        debugPrint('[Auth][Google] ⑥ 直接 signInWithCredential');
        await auth.signInWithCredential(credential);
        if (!ref.mounted) return;
        debugPrint('[Auth][Google] ⑥ signInWithCredential 成功');
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        debugPrint('[Auth][Google] ⑧ ERROR: currentUser が null — サインイン失敗');
        throw Exception('サインインに失敗しました（UID取得不可）。再度お試しください。');
      }
      debugPrint('[Auth][Google] ⑧ Firebase サインイン完了: uid=$uid');

      _backupLocalDataToFirestore(uid);
      debugPrint('[Auth][Google] ⑨ 完了（バックアップはバックグラウンドで継続）');
      if (ref.mounted) state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('[Auth][Google] ❌ エラー: $e');
      debugPrint('[Auth][Google] StackTrace: $st');
      final message = _friendlyAuthError(e);
      if (ref.mounted) state = AsyncError(Exception(message), st);
    }
  }

  /// Apple Sign-In を行い、匿名アカウントならリンク、非匿名なら直接サインイン。
  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    try {
      final auth = ref.read(firebaseAuthProvider);
      debugPrint('[Auth][Apple] ① 開始 — 現在UID: ${auth.currentUser?.uid}');

      final AuthorizationCredentialAppleID appleCredential;
      try {
        debugPrint('[Auth][Apple] ② getAppleIDCredential 呼び出し（ダイアログ表示待ち）');
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      } on SignInWithAppleAuthorizationException catch (e) {
        debugPrint('[Auth][Apple] ② 例外: code=${e.code} message=${e.message}');
        if (e.code == AuthorizationErrorCode.canceled) {
          debugPrint('[Auth][Apple] ② キャンセル検出 — state を AsyncData に戻す');
          if (ref.mounted) state = const AsyncData(null);
          return;
        }
        throw Exception(_friendlyAppleError(e));
      }
      if (!ref.mounted) return;
      debugPrint('[Auth][Apple] ③ 認証完了 — email: ${appleCredential.email}, '
          'identityToken: ${appleCredential.identityToken != null ? "取得済み" : "null"}');

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      debugPrint('[Auth][Apple] ④ OAuthCredential 生成完了');

      final currentUser = auth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        debugPrint('[Auth][Apple] ⑤ 匿名→Appleリンク試行: uid=${currentUser.uid}');
        try {
          await currentUser.linkWithCredential(oauthCredential);
          if (!ref.mounted) return;
          debugPrint('[Auth][Apple] ⑤ linkWithCredential 成功');
        } on FirebaseAuthException catch (e) {
          debugPrint('[Auth][Apple] ⑤ linkWithCredential エラー: code=${e.code} message=${e.message}');
          if (e.code == 'credential-already-in-use' ||
              e.code == 'account-exists-with-different-credential' ||
              e.code == 'email-already-in-use') {
            debugPrint('[Auth][Apple] ⑥ 既存アカウントへ signInWithCredential (code=${e.code})');
            await auth.signInWithCredential(oauthCredential);
            if (!ref.mounted) return;
            debugPrint('[Auth][Apple] ⑥ signInWithCredential 成功');
          } else {
            // raw FirebaseAuthException をそのまま rethrow して _friendlyAuthError で処理
            rethrow;
          }
        }
      } else {
        debugPrint('[Auth][Apple] ⑤ 直接 signInWithCredential');
        await auth.signInWithCredential(oauthCredential);
        if (!ref.mounted) return;
        debugPrint('[Auth][Apple] ⑤ signInWithCredential 成功');
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        debugPrint('[Auth][Apple] ⑦ ERROR: currentUser が null — サインイン失敗');
        throw Exception('サインインに失敗しました（UID取得不可）。再度お試しください。');
      }
      debugPrint('[Auth][Apple] ⑦ サインイン完了: uid=$uid');
      _backupLocalDataToFirestore(uid);
      if (ref.mounted) state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('[Auth][Apple] ❌ エラー: $e');
      debugPrint('[Auth][Apple] StackTrace: $st');
      final message = _friendlyAuthError(e);
      if (ref.mounted) state = AsyncError(Exception(message), st);
    }
  }

  /// 例外をユーザー向けの日本語メッセージに変換する
  String _friendlyAuthError(Object e) {
    final msg = e.toString();
    if (msg.contains('network') || msg.contains('Network')) {
      return 'ネットワークエラーが発生しました。通信環境を確認してください。';
    }
    if (msg.contains('canceled') || msg.contains('cancelled')) {
      return 'サインインがキャンセルされました。';
    }
    if (msg.contains('sign_in_failed') || msg.contains('ApiException: 10')) {
      return 'Google サインインに失敗しました。Google Play開発者サービスの設定を確認してください。';
    }
    if (msg.contains('credential-already-in-use')) {
      return 'このアカウントは既に別のユーザーに紐付けられています。';
    }
    if (msg.contains('account-exists-with-different-credential')) {
      return '同じメールアドレスで別の方法（Google/Apple）のアカウントが既に存在します。';
    }
    if (msg.contains('email-already-in-use')) {
      return 'このメールアドレスは既に使用されています。';
    }
    if (msg.contains('user-disabled')) {
      return 'このアカウントは無効化されています。サポートにお問い合わせください。';
    }
    if (msg.contains('CONFIGURATION_NOT_FOUND') || msg.contains('configuration')) {
      return 'Apple Sign-In の設定が完了していません。実機でお試しください（シミュレータでは動作しない場合があります）。';
    }
    if (e is FirebaseAuthException) {
      debugPrint('[Auth] FirebaseAuthException: code=${e.code} message=${e.message}');
      return 'Firebase認証エラー (${e.code}): ${e.message ?? e.code}';
    }
    return 'サインインに失敗しました。しばらく時間をおいて再試行してください。\n詳細: $msg';
  }

  /// Apple Sign-In 固有のエラーをユーザー向けメッセージに変換する
  String _friendlyAppleError(SignInWithAppleAuthorizationException e) {
    switch (e.code) {
      case AuthorizationErrorCode.invalidResponse:
        return 'Apple Sign-In の応答が無効です。実機でお試しください（シミュレータでは動作しない場合があります）。';
      case AuthorizationErrorCode.notHandled:
      case AuthorizationErrorCode.failed:
        return 'Apple Sign-In に失敗しました。実機でお試しください。';
      case AuthorizationErrorCode.notInteractive:
        return 'Apple Sign-In のダイアログを表示できませんでした。';
      case AuthorizationErrorCode.unknown:
        // entitlements 不足や iOS 設定不備の際に返されるコード
        return 'Apple Sign-In が利用できません。Apple ID 設定または App の権限設定を確認してください。';
      default:
        return 'Apple Sign-In エラー: ${e.message}';
    }
  }

  /// アカウントおよび全関連データを削除する
  ///
  /// 1. Firestore の users/{uid} 配下のサブコレクションを全削除
  /// 2. Firestore の users/{uid} ドキュメントを削除
  /// 3. Firebase Auth のアカウントを削除
  ///
  /// 注意: Firestore Security Rules で request.auth.uid == uid の制限が
  /// かかっていることを前提とする。
  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(firebaseAuthProvider);
      final uid = auth.currentUser?.uid;
      if (uid == null) return;

      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(uid);

      // サブコレクションを順に削除（Firestore はサブコレクションを自動削除しない）
      for (final sub in ['tasks', 'task_records', 'growth_records', 'daily_summary']) {
        final snap = await userDocRef.collection(sub).get();
        final batch = firestore.batch();
        for (final doc in snap.docs) {
          batch.delete(doc.reference);
        }
        if (snap.docs.isNotEmpty) await batch.commit();
      }

      // ユーザードキュメント本体を削除
      await userDocRef.delete();

      // Firebase Auth アカウントを削除
      await auth.currentUser?.delete();
    });
  }

  /// Firestoreのバッチ書き込み上限（500件）を超えないよう分割してコミットする
  Future<void> _commitInChunks(
    FirebaseFirestore firestore,
    List<Map<String, dynamic>> docs,
    CollectionReference colRef,
  ) async {
    const chunkSize = 400; // 余裕を持って400件単位
    for (var i = 0; i < docs.length; i += chunkSize) {
      final chunk = docs.sublist(i, i + chunkSize > docs.length ? docs.length : i + chunkSize);
      final batch = firestore.batch();
      for (final item in chunk) {
        final docRef = colRef.doc(item['id'] as String);
        batch.set(docRef, item, SetOptions(merge: true));
      }
      await batch.commit();
      debugPrint('[Backup] バッチコミット完了: ${i + chunk.length}/${docs.length}件');
    }
  }

  /// 初回サインイン時にSQLiteからFirestoreへ全データをバックアップする
  ///
  /// フラグは 'initial_backup_done_$uid' としてUID別に管理する。
  /// fire-and-forget で呼び出すこと（UIをブロックしない）。
  Future<void> _backupLocalDataToFirestore(String uid) async {
    try {
      debugPrint('[Backup] 開始: uid=$uid');
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('initial_backup_done_$uid') ?? false) {
        debugPrint('[Backup] スキップ（既にバックアップ済み）');
        return;
      }

      debugPrint('[Backup] タスク取得中...');
      final taskRepo = await ref.read(taskRepositoryProvider.future);
      final localTasks = await taskRepo.watchAllTasks().first;
      debugPrint('[Backup] タスク取得完了: ${localTasks.length}件');

      if (localTasks.isEmpty) {
        await prefs.setBool('initial_backup_done_$uid', true);
        debugPrint('[Backup] タスクなし。完了フラグを立てて終了');
        return;
      }

      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(uid);

      // Tasks のバックアップ（分割コミット）
      debugPrint('[Backup] タスクをFirestoreへ書き込み中...');
      await _commitInChunks(
        firestore,
        localTasks.map((t) => t.toJson()).toList(),
        userDocRef.collection('tasks'),
      );

      // TaskRecords のバックアップ（分割コミット）
      debugPrint('[Backup] 記録を取得中...');
      final recordRepo = ref.read(taskRecordRepositoryProvider);
      final allRecords = await recordRepo.fetchRecentRecords(
        since: DateTime.fromMillisecondsSinceEpoch(0),
      );
      debugPrint('[Backup] 記録取得完了: ${allRecords.length}件。Firestoreへ書き込み中...');
      await _commitInChunks(
        firestore,
        allRecords.map((r) => r.toJson()).toList(),
        userDocRef.collection('task_records'),
      );

      // GrowthRecords のバックアップ（分割コミット）
      debugPrint('[Backup] 成長記録の移行中...');
      final growthRepo = await ref.read(localGrowthRepositoryProvider.future);
      await growthRepo.updateUserId(kLocalUserId, uid);
      final allGrowthRecords = await growthRepo.fetchAllRecordsByUser(uid);
      debugPrint('[Backup] 成長記録取得完了: ${allGrowthRecords.length}件。Firestoreへ書き込み中...');
      await _commitInChunks(
        firestore,
        allGrowthRecords.map((r) => r.toJson()).toList(),
        userDocRef.collection('growth_records'),
      );

      await prefs.setBool('initial_backup_done_$uid', true);
      debugPrint('[Backup] 完了: タスク${localTasks.length}件 / 記録${allRecords.length}件 / 成長${allGrowthRecords.length}件');
    } catch (e, st) {
      debugPrint('[Backup] 失敗: $e\n$st');
      // バックアップ失敗はユーザー操作をブロックしない（次回サインイン時に再試行）
    }
  }
}
