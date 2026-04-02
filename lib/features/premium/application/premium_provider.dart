import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_provider.dart';
import 'premium_status_notifier.dart';

part 'premium_provider.g.dart';

/// Firestoreのユーザー情報をリアルタイム監視します。
@riverpod
Stream<Map<String, dynamic>?> userPrivateData(Ref ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == kLocalUserId) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) => doc.data());
}

/// プレミアム状態を判定するProvider。
///
/// 【信頼性の優先順位】
/// 1. Firestore の isPremium（サーバー権威情報・改ざん不可）
/// 2. IAP/SharedPreferences（端末情報・即時反映のため補完として使用）
///
/// クラウド同期などの重要機能では Firestore 側を信頼性の高いソースとして優先する。
/// IAP は購入直後に Firestore が未更新の場合の即時反映のみを目的とする。
///
/// 【Firebase Security Rules 備忘録】
/// Firestore の users/{uid} 配下のデータには必ず以下のルールを適用すること:
///   match /users/{uid}/{document=**} {
///     allow read, write: if request.auth != null && request.auth.uid == uid;
///   }
/// これにより、認証済みユーザーが自分のデータにのみアクセスできることを保証する。
@riverpod
AsyncValue<bool> isPremium(Ref ref) {
  // Firestore 由来のプレミアム状態（サーバー権威情報として優先）
  final firestoreState = ref.watch(userPrivateDataProvider);
  final firestorePremium = firestoreState.value?['isPremium'] == true;

  // Firestore がロード完了しており true → 確定でプレミアム
  if (firestoreState.hasValue && firestorePremium) {
    return const AsyncData(true);
  }

  // Firestore がロード完了しており false → IAP で補完（購入直後の即時反映）
  if (firestoreState.hasValue && !firestorePremium) {
    final iapState = ref.watch(premiumStatusProvider);
    final iapPremium = iapState.value?.isPremium ?? false;
    if (iapPremium) return const AsyncData(true);
    if (iapState.isLoading) return const AsyncLoading();
    return const AsyncData(false);
  }

  // Firestore がロード中
  if (firestoreState.isLoading) {
    return const AsyncLoading();
  }

  // Firestore がエラー → IAP にフォールバック（オフライン時も動作させる）
  final iapState = ref.watch(premiumStatusProvider);
  if (iapState.value?.isPremium == true) return const AsyncData(true);
  if (iapState.isLoading) return const AsyncLoading();
  return const AsyncData(false);
}

/// プレミアムが解除された日時（24時間の猶予期間判定用）
@riverpod
Timestamp? premiumExpiredAt(Ref ref) {
  final data = ref.watch(userPrivateDataProvider).value;
  return data?['premiumExpiredAt'] as Timestamp?;
}
