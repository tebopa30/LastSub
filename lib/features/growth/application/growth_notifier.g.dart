// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(growthRecordsStream)
final growthRecordsStreamProvider = GrowthRecordsStreamProvider._();

final class GrowthRecordsStreamProvider extends $FunctionalProvider<
        AsyncValue<List<GrowthRecordEntity>>,
        List<GrowthRecordEntity>,
        Stream<List<GrowthRecordEntity>>>
    with
        $FutureModifier<List<GrowthRecordEntity>>,
        $StreamProvider<List<GrowthRecordEntity>> {
  GrowthRecordsStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'growthRecordsStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$growthRecordsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<GrowthRecordEntity>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<GrowthRecordEntity>> create(Ref ref) {
    return growthRecordsStream(ref);
  }
}

String _$growthRecordsStreamHash() =>
    r'd402314d71b2d7ba7c66da2c77ee5319073b77b4';

@ProviderFor(GrowthNotifier)
final growthProvider = GrowthNotifierProvider._();

final class GrowthNotifierProvider
    extends $NotifierProvider<GrowthNotifier, void> {
  GrowthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'growthProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$growthNotifierHash();

  @$internal
  @override
  GrowthNotifier create() => GrowthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$growthNotifierHash() => r'eca10126ac5e610fae51486ba75708ef9f53543d';

abstract class _$GrowthNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
