// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigator_key_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(navigatorKey)
final navigatorKeyProvider = NavigatorKeyProvider._();

final class NavigatorKeyProvider extends $FunctionalProvider<
    GlobalKey<NavigatorState>,
    GlobalKey<NavigatorState>,
    GlobalKey<NavigatorState>> with $Provider<GlobalKey<NavigatorState>> {
  NavigatorKeyProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'navigatorKeyProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$navigatorKeyHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<NavigatorState>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GlobalKey<NavigatorState> create(Ref ref) {
    return navigatorKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<NavigatorState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<NavigatorState>>(value),
    );
  }
}

String _$navigatorKeyHash() => r'e98ea9b83a531ebfa207927a585fc0549744a9c1';
