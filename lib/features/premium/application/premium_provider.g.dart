// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Firestoreのユーザー情報をリアルタイム監視します。

@ProviderFor(userPrivateData)
final userPrivateDataProvider = UserPrivateDataProvider._();

/// Firestoreのユーザー情報をリアルタイム監視します。

final class UserPrivateDataProvider extends $FunctionalProvider<
        AsyncValue<Map<String, dynamic>?>,
        Map<String, dynamic>?,
        Stream<Map<String, dynamic>?>>
    with
        $FutureModifier<Map<String, dynamic>?>,
        $StreamProvider<Map<String, dynamic>?> {
  /// Firestoreのユーザー情報をリアルタイム監視します。
  UserPrivateDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userPrivateDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userPrivateDataHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, dynamic>?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<String, dynamic>?> create(Ref ref) {
    return userPrivateData(ref);
  }
}

String _$userPrivateDataHash() => r'15debeadcf07fa51bdc9695afeda0776c5bcdebd';

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

@ProviderFor(isPremium)
final isPremiumProvider = IsPremiumProvider._();

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

final class IsPremiumProvider extends $FunctionalProvider<AsyncValue<bool>,
    AsyncValue<bool>, AsyncValue<bool>> with $Provider<AsyncValue<bool>> {
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
  IsPremiumProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isPremiumProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isPremiumHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<bool>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<bool> create(Ref ref) {
    return isPremium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$isPremiumHash() => r'd1503af6e7192c0079cd7eaebc9bb6e40e3f86ef';

/// プレミアムが解除された日時（24時間の猶予期間判定用）

@ProviderFor(premiumExpiredAt)
final premiumExpiredAtProvider = PremiumExpiredAtProvider._();

/// プレミアムが解除された日時（24時間の猶予期間判定用）

final class PremiumExpiredAtProvider
    extends $FunctionalProvider<Timestamp?, Timestamp?, Timestamp?>
    with $Provider<Timestamp?> {
  /// プレミアムが解除された日時（24時間の猶予期間判定用）
  PremiumExpiredAtProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'premiumExpiredAtProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$premiumExpiredAtHash();

  @$internal
  @override
  $ProviderElement<Timestamp?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Timestamp? create(Ref ref) {
    return premiumExpiredAt(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Timestamp? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Timestamp?>(value),
    );
  }
}

String _$premiumExpiredAtHash() => r'e4615d007b497aaa31ef9aa939c739210bef2b8b';
