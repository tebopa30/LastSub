// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_status_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SharedPreferencesを提供するProvider
/// `main()` 関数などで `await SharedPreferences.getInstance()` し、
/// `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])`
/// のように上書きして使います。

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// SharedPreferencesを提供するProvider
/// `main()` 関数などで `await SharedPreferences.getInstance()` し、
/// `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])`
/// のように上書きして使います。

final class SharedPreferencesProvider extends $FunctionalProvider<
    SharedPreferences,
    SharedPreferences,
    SharedPreferences> with $Provider<SharedPreferences> {
  /// SharedPreferencesを提供するProvider
  /// `main()` 関数などで `await SharedPreferences.getInstance()` し、
  /// `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])`
  /// のように上書きして使います。
  SharedPreferencesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPreferencesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'19dca3396f79491fdbca157ef3735255dad4242e';

/// PremiumRepositoryを提供するProvider

@ProviderFor(premiumRepository)
final premiumRepositoryProvider = PremiumRepositoryProvider._();

/// PremiumRepositoryを提供するProvider

final class PremiumRepositoryProvider extends $FunctionalProvider<
    PremiumRepository,
    PremiumRepository,
    PremiumRepository> with $Provider<PremiumRepository> {
  /// PremiumRepositoryを提供するProvider
  PremiumRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'premiumRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$premiumRepositoryHash();

  @$internal
  @override
  $ProviderElement<PremiumRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PremiumRepository create(Ref ref) {
    return premiumRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PremiumRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PremiumRepository>(value),
    );
  }
}

String _$premiumRepositoryHash() => r'9897ea07bc3943331d34369c25d26e34e2e15ac3';

/// デバッグ専用：プレミアム強制フラグを永続化・管理するNotifier

@ProviderFor(PremiumStatusNotifier)
final premiumStatusProvider = PremiumStatusNotifierProvider._();

/// デバッグ専用：プレミアム強制フラグを永続化・管理するNotifier
final class PremiumStatusNotifierProvider extends $StreamNotifierProvider<
    PremiumStatusNotifier, PremiumStatusEntity> {
  /// デバッグ専用：プレミアム強制フラグを永続化・管理するNotifier
  PremiumStatusNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'premiumStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$premiumStatusNotifierHash();

  @$internal
  @override
  PremiumStatusNotifier create() => PremiumStatusNotifier();
}

String _$premiumStatusNotifierHash() =>
    r'57451cffa391e9b00c073d998d741e39d6fa32c7';

/// デバッグ専用：プレミアム強制フラグを永続化・管理するNotifier

abstract class _$PremiumStatusNotifier
    extends $StreamNotifier<PremiumStatusEntity> {
  Stream<PremiumStatusEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PremiumStatusEntity>, PremiumStatusEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<PremiumStatusEntity>, PremiumStatusEntity>,
        AsyncValue<PremiumStatusEntity>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
