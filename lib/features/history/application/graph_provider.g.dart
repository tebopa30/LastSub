// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// taskId → タスク表示名 のマッピング

@ProviderFor(weeklyGraphTaskNames)
final weeklyGraphTaskNamesProvider = WeeklyGraphTaskNamesProvider._();

/// taskId → タスク表示名 のマッピング

final class WeeklyGraphTaskNamesProvider extends $FunctionalProvider<
    Map<String, String>,
    Map<String, String>,
    Map<String, String>> with $Provider<Map<String, String>> {
  /// taskId → タスク表示名 のマッピング
  WeeklyGraphTaskNamesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weeklyGraphTaskNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyGraphTaskNamesHash();

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    return weeklyGraphTaskNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$weeklyGraphTaskNamesHash() =>
    r'b9b52dc86a545f85271d392d2d731821c6c9def7';

/// taskId → 指定期間の実行回数リスト（ローカルSQLiteから集計）

@ProviderFor(weeklyGraphData)
final weeklyGraphDataProvider = WeeklyGraphDataProvider._();

/// taskId → 指定期間の実行回数リスト（ローカルSQLiteから集計）

final class WeeklyGraphDataProvider extends $FunctionalProvider<
    Map<String, List<int>>,
    Map<String, List<int>>,
    Map<String, List<int>>> with $Provider<Map<String, List<int>>> {
  /// taskId → 指定期間の実行回数リスト（ローカルSQLiteから集計）
  WeeklyGraphDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weeklyGraphDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyGraphDataHash();

  @$internal
  @override
  $ProviderElement<Map<String, List<int>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, List<int>> create(Ref ref) {
    return weeklyGraphData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<int>>>(value),
    );
  }
}

String _$weeklyGraphDataHash() => r'89353a59189f6538581a51d6bbd34c9b698d1afd';

/// UI用のグラフ表示状態を生成するProvider

@ProviderFor(historyGraphState)
final historyGraphStateProvider = HistoryGraphStateProvider._();

/// UI用のグラフ表示状態を生成するProvider

final class HistoryGraphStateProvider extends $FunctionalProvider<
    HistoryGraphState,
    HistoryGraphState,
    HistoryGraphState> with $Provider<HistoryGraphState> {
  /// UI用のグラフ表示状態を生成するProvider
  HistoryGraphStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'historyGraphStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historyGraphStateHash();

  @$internal
  @override
  $ProviderElement<HistoryGraphState> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HistoryGraphState create(Ref ref) {
    return historyGraphState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryGraphState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryGraphState>(value),
    );
  }
}

String _$historyGraphStateHash() => r'0f2b1dc38d06692289e7b9fb2d6dfb04c6609c1f';
