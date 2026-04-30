// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MotivationNotifier)
final motivationProvider = MotivationNotifierProvider._();

final class MotivationNotifierProvider
    extends $NotifierProvider<MotivationNotifier, MotivationState> {
  MotivationNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'motivationProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$motivationNotifierHash();

  @$internal
  @override
  MotivationNotifier create() => MotivationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MotivationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MotivationState>(value),
    );
  }
}

String _$motivationNotifierHash() =>
    r'394f6f5376fb08aa316009123c74f7380563d8d2';

abstract class _$MotivationNotifier extends $Notifier<MotivationState> {
  MotivationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MotivationState, MotivationState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MotivationState, MotivationState>,
        MotivationState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(globalHealth)
final globalHealthProvider = GlobalHealthProvider._();

final class GlobalHealthProvider
    extends $FunctionalProvider<GlobalHealth, GlobalHealth, GlobalHealth>
    with $Provider<GlobalHealth> {
  GlobalHealthProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'globalHealthProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$globalHealthHash();

  @$internal
  @override
  $ProviderElement<GlobalHealth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GlobalHealth create(Ref ref) {
    return globalHealth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalHealth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalHealth>(value),
    );
  }
}

String _$globalHealthHash() => r'a8b5ed7332ae2e875d984abb622becb75e6d6c9d';
