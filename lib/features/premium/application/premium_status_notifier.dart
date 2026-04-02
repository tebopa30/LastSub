import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/premium_status_entity.dart';
import '../domain/premium_repository.dart';
import '../infrastructure/iap_premium_repository.dart';
import '../../auth/application/auth_provider.dart';

part 'premium_status_notifier.g.dart';

// ===== ProviderScope override 等で利用するProvider定義 =====

/// SharedPreferencesを提供するProvider
/// `main()` 関数などで `await SharedPreferences.getInstance()` し、
/// `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])`
/// のように上書きして使います。
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('Initialize this provider in ProviderScope overrides');
}

/// PremiumRepositoryを提供するProvider
@Riverpod(keepAlive: true)
PremiumRepository premiumRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repository = IAPPremiumRepository(InAppPurchase.instance, prefs);
  
  // Providerが破棄される時にRepositoryのdisposeを呼ぶ
  ref.onDispose(() {
    repository.dispose();
  });
  
  return repository;
}

// ===== PremiumStatusNotifier 実装 =====

/// デバッグ専用：プレミアム強制フラグを永続化・管理するNotifier
@riverpod
class PremiumStatusNotifier extends _$PremiumStatusNotifier {
  @override
  Stream<PremiumStatusEntity> build() {
    // デバッグフラグの監視
    final prefs = ref.watch(sharedPreferencesProvider);
    final debugOverride = prefs.getBool('is_premium') ?? false;

    // デバッグビルド時かつフラグが有効な場合は即座にプレミアム状態を返す
    if (kDebugMode && debugOverride) {
      return Stream.value(const PremiumStatusEntity(isPremium: true));
    }

    // 通常時はリポジトリの状態を監視
    final repository = ref.watch(premiumRepositoryProvider);

    // ストリームをラップし、isPremium が変化した瞬間だけ Firestore へ同期する
    // asyncMap のクロージャで前回値を保持（初回は同期しない）
    bool? lastIsPremium;
    return repository.premiumStatusStream.asyncMap((entity) async {
      if (lastIsPremium != null && lastIsPremium != entity.isPremium) {
        await _syncToFirestore(entity.isPremium);
      }
      lastIsPremium = entity.isPremium;
      return entity;
    });
  }

  /// 購入・解約検出時に Firestore の isPremium / premiumExpiredAt を同期する
  Future<void> _syncToFirestore(bool isPremium) async {
    try {
      final uid = ref.read(currentUidProvider);
      if (uid == kLocalUserId) return;

      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await docRef.set(
        {
          'isPremium': isPremium,
          // 解約時: 猶予期間の起点を記録 / 購入・復元時: null でクリア
          'premiumExpiredAt': isPremium ? null : FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('Firestore premium sync failed: $e');
    }
  }

  /// プレミアムを購入する
  Future<void> buyPremium() async {
    final repository = ref.read(premiumRepositoryProvider);
    await repository.buyPremium();
  }

  /// プレミアムを復元する
  Future<void> restorePurchase() async {
    final repository = ref.read(premiumRepositoryProvider);
    await repository.restorePurchase();
  }

  /// デバッグ専用：プレミアム状態を強制設定する
  Future<void> setDebugPremium(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('is_premium', value);
    // 状態を強制的に再読込させる
    ref.invalidateSelf();
  }
}
