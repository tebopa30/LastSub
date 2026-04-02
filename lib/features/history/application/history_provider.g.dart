// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryPeriod)
final historyPeriodProvider = HistoryPeriodProvider._();

final class HistoryPeriodProvider
    extends $NotifierProvider<HistoryPeriod, int?> {
  HistoryPeriodProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'historyPeriodProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historyPeriodHash();

  @$internal
  @override
  HistoryPeriod create() => HistoryPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$historyPeriodHash() => r'480cd773c8d541b902c4b9eff475ee6f657642ce';

abstract class _$HistoryPeriod extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<int?, int?>, int?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(HistoryNotifier)
final historyNotifierProvider = HistoryNotifierProvider._();

final class HistoryNotifierProvider
    extends $NotifierProvider<HistoryNotifier, bool> {
  HistoryNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'historyNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historyNotifierHash();

  @$internal
  @override
  HistoryNotifier create() => HistoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$historyNotifierHash() => r'beedb6f23675e603d7f9446fe20fcf0790e6c559';

abstract class _$HistoryNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(allTasksStream)
final allTasksStreamProvider = AllTasksStreamProvider._();

final class AllTasksStreamProvider extends $FunctionalProvider<
        AsyncValue<List<TaskEntity>>,
        List<TaskEntity>,
        Stream<List<TaskEntity>>>
    with $FutureModifier<List<TaskEntity>>, $StreamProvider<List<TaskEntity>> {
  AllTasksStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allTasksStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allTasksStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskEntity>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TaskEntity>> create(Ref ref) {
    return allTasksStream(ref);
  }
}

String _$allTasksStreamHash() => r'90d4fd9da1d4bbcd4074d702eea8a43e06798313';

@ProviderFor(recentRecordsStream)
final recentRecordsStreamProvider = RecentRecordsStreamProvider._();

final class RecentRecordsStreamProvider extends $FunctionalProvider<
        AsyncValue<List<TaskRecordEntity>>,
        List<TaskRecordEntity>,
        Stream<List<TaskRecordEntity>>>
    with
        $FutureModifier<List<TaskRecordEntity>>,
        $StreamProvider<List<TaskRecordEntity>> {
  RecentRecordsStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recentRecordsStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recentRecordsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskRecordEntity>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TaskRecordEntity>> create(Ref ref) {
    return recentRecordsStream(ref);
  }
}

String _$recentRecordsStreamHash() =>
    r'41779d8e38573b2a4c9feba689aecb5fea1b2fc2';

@ProviderFor(historyGrouped)
final historyGroupedProvider = HistoryGroupedProvider._();

final class HistoryGroupedProvider extends $FunctionalProvider<
        Map<String, List<HistoryItem>>,
        Map<String, List<HistoryItem>>,
        Map<String, List<HistoryItem>>>
    with $Provider<Map<String, List<HistoryItem>>> {
  HistoryGroupedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'historyGroupedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historyGroupedHash();

  @$internal
  @override
  $ProviderElement<Map<String, List<HistoryItem>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, List<HistoryItem>> create(Ref ref) {
    return historyGrouped(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<HistoryItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<String, List<HistoryItem>>>(value),
    );
  }
}

String _$historyGroupedHash() => r'be07dd1750e008071c37bccda30f25e8486ece36';

/// 日付ごとに、さらにタスクごとにグループ化した履歴
/// Map<dateStr, List<GroupedTaskItem>>

@ProviderFor(historyGroupedByTask)
final historyGroupedByTaskProvider = HistoryGroupedByTaskProvider._();

/// 日付ごとに、さらにタスクごとにグループ化した履歴
/// Map<dateStr, List<GroupedTaskItem>>

final class HistoryGroupedByTaskProvider extends $FunctionalProvider<
        Map<String, List<GroupedTaskItem>>,
        Map<String, List<GroupedTaskItem>>,
        Map<String, List<GroupedTaskItem>>>
    with $Provider<Map<String, List<GroupedTaskItem>>> {
  /// 日付ごとに、さらにタスクごとにグループ化した履歴
  /// Map<dateStr, List<GroupedTaskItem>>
  HistoryGroupedByTaskProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'historyGroupedByTaskProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historyGroupedByTaskHash();

  @$internal
  @override
  $ProviderElement<Map<String, List<GroupedTaskItem>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, List<GroupedTaskItem>> create(Ref ref) {
    return historyGroupedByTask(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<GroupedTaskItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<String, List<GroupedTaskItem>>>(value),
    );
  }
}

String _$historyGroupedByTaskHash() =>
    r'2cf6ac433b8c36d34f825772789e9777d0e1e8e2';
