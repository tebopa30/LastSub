import 'premium_status_entity.dart';

/// プレミアム課金機能のリポジトリ抽象
abstract class PremiumRepository {
  /// 現在プレミアム状態かどうかを取得する（ローカル/キャッシュ用）
  Future<bool> getIsPremium();

  /// プレミアム購入を処理する
  Future<void> buyPremium();

  /// 購入履歴を復元する
  Future<void> restorePurchase();

  /// 購入状態変更のストリーム（外部から監視用）
  Stream<PremiumStatusEntity> get premiumStatusStream;
}
