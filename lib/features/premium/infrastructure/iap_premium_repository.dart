import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/premium_repository.dart';
import '../domain/premium_status_entity.dart';

class IAPPremiumRepository implements PremiumRepository {
  IAPPremiumRepository(this._inAppPurchase, this._prefs) {
    _initPurchaseStream();
  }

  final InAppPurchase _inAppPurchase;
  final SharedPreferences _prefs;

  // プレミアムのプロダクトID（月額サブスクリプション）
  static const String _kPremiumProductId = 'com.itukara.premium.monthly_sub';
  // プレミアム状態を保存するキー
  static const String _kIsPremiumPrefKey = 'is_premium';

  // 内部でPurchaseStatus等の更新を管理し、Entityとして外部に流すStreamController
  final _statusController = StreamController<PremiumStatusEntity>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  void _initPurchaseStream() {
    // in_app_purchaseからStreamの通知を受け取る
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        _statusController.add(PremiumStatusEntity(
          isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
          errorMessage: '購入処理のエラーが発生しました: $error',
        ));
      },
    );
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 購入処理中
        _statusController.add(PremiumStatusEntity(
          isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
          isLoading: true,
        ));
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // 購入エラー
          _statusController.add(PremiumStatusEntity(
            isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
            errorMessage: purchaseDetails.error?.message ?? '購入エラーが発生しました',
          ));
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // 購入完了 または 復元完了
          
          // 最低限の検証処理 (サーバー検証が必要な場合はここでサーバーAPIを叩く)
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // プレミアム状態をローカルに永続化
            await _prefs.setBool(_kIsPremiumPrefKey, true);
            _statusController.add(const PremiumStatusEntity(
              isPremium: true,
              isLoading: false,
            ));
          } else {
            // 検証失敗
            _statusController.add(PremiumStatusEntity(
              isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
              errorMessage: '購入の検証に失敗しました。',
            ));
          }
        }
        
        // **重要** pendingCompletePurchaseがtrueの場合は必ずcompletePurchaseを呼ぶ
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 要件: verificationData.serverVerificationDataを確認する最低限の検証処理
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // 本来は purchaseDetails.verificationData.serverVerificationData を
    // 自前サーバーに送付して、Appleのサーバーでレシート検証を行うのが安全です。
    // ここでは最低限のデータ存在チェックを行います。
    if (purchaseDetails.verificationData.serverVerificationData.isEmpty) {
      if (kDebugMode) {
        print('Warning: サーバー検証データが空です。');
      }
      return false; 
    }
    
    // TODO: ここで実際の検証API（例: FastAPIのエンドポイント）へ
    // purchaseDetails.verificationData.serverVerificationData 
    // を送信し、検証結果を受け取る実装を追加してください。
    
    // 現在は最低限のチェックを通過したため検証成功とする
    return true;
  }

  /// インスタンス破棄時にはStream監視も終了(dispose含む)
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }

  @override
  Stream<PremiumStatusEntity> get premiumStatusStream async* {
    final initialIsPremium = _prefs.getBool(_kIsPremiumPrefKey) ?? false;
    yield PremiumStatusEntity(isPremium: initialIsPremium);
    yield* _statusController.stream;
  }

  @override
  Future<bool> getIsPremium() async {
    return _prefs.getBool(_kIsPremiumPrefKey) ?? false;
  }

  @override
  Future<void> buyPremium() async {
    // ローディング開始
    _statusController.add(PremiumStatusEntity(
      isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
      isLoading: true,
    ));

    // in_app_purchaseの利用可否確認
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _statusController.add(PremiumStatusEntity(
        isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
        errorMessage: '現在、アプリ内課金が利用できません。',
      ));
      return;
    }

    // queryProductDetailsを使用
    const Set<String> kIds = <String>{_kPremiumProductId};
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(kIds);

    // エラーハンドリング
    if (productDetailResponse.error != null) {
      _statusController.add(PremiumStatusEntity(
        isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
        errorMessage: 'ストアとの通信エラー: ${productDetailResponse.error!.message}',
      ));
      return;
    }

    // product not foundの場合のエラーハンドリング
    if (productDetailResponse.productDetails.isEmpty) {
      _statusController.add(PremiumStatusEntity(
        isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
        errorMessage: 'プレミアム課金アイテムが見つかりません。',
      ));
      return;
    }

    // アイテムが見つかったので購入フローを開始
    final ProductDetails productDetails =
        productDetailResponse.productDetails.first;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    try {
      // purchaseType: non_consumable として課金開始
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      // 結果は purchaseStream から _onPurchaseUpdate でハンドリングされるためここまで
    } catch (e) {
      _statusController.add(PremiumStatusEntity(
        isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
        errorMessage: '購入処理が開始できませんでした。: $e',
      ));
    }
  }

  @override
  Future<void> restorePurchase() async {
    // ローディング開始
    _statusController.add(PremiumStatusEntity(
      isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
      isLoading: true,
    ));
    
    try {
      // 復元処理を実行
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _statusController.add(PremiumStatusEntity(
        isPremium: _prefs.getBool(_kIsPremiumPrefKey) ?? false,
        errorMessage: '購入の復元に失敗しました。: $e',
      ));
    }
  }
}
