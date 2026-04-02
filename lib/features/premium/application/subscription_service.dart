import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'premium_status_notifier.dart';

// ──────────────────────────────────────────────────────────────
// Subscription Service
// ──────────────────────────────────────────────────────────────
// 月額プレミアム課金の UI 操作（購入・復元）を提供するサービス。
// IAP ストリーム監視と SharedPreferences 永続化は
// IAPPremiumRepository（premiumRepositoryProvider 経由）に委譲し、
// 二重リスナー問題を防ぐ。
// ──────────────────────────────────────────────────────────────

/// サブスクリプションのプロダクトID
const String kMonthlySubscriptionId = 'com.itukara.premium.monthly_sub';

/// サブスクリプション処理での UI 状態（ローディング・エラー）
class SubscriptionState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SubscriptionState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// サブスクリプション課金の UI 操作を提供する Notifier。
/// 実際の IAP ストリーム処理は premiumRepositoryProvider に委譲。
class SubscriptionServiceNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() {
    return const SubscriptionState();
  }

  /// プレミアム月額プランを購入する
  Future<void> buyMonthlySubscription() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final repo = ref.read(premiumRepositoryProvider);
      await repo.buyPremium();
      // 購入完了通知は purchaseStream → IAPPremiumRepository → premiumStatusProvider 経由で届く
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '購入処理を開始できませんでした: $e',
      );
    }
  }

  /// 購入履歴を復元する
  Future<void> restorePurchase() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final repo = ref.read(premiumRepositoryProvider);
      await repo.restorePurchase();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '購入の復元に失敗しました: $e',
      );
    }
  }
}

/// UI 側から監視・操作するための Provider
final subscriptionServiceProvider =
    NotifierProvider<SubscriptionServiceNotifier, SubscriptionState>(
        SubscriptionServiceNotifier.new);
