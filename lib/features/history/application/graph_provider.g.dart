// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weeklyGraphTaskNames)
final weeklyGraphTaskNamesProvider = WeeklyGraphTaskNamesProvider._();

final class WeeklyGraphTaskNamesProvider extends $FunctionalProvider<
    Map<String, String>,
    Map<String, String>,
    Map<String, String>> with $Provider<Map<String, String>> {
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

@ProviderFor(weeklyGraphData)
final weeklyGraphDataProvider = WeeklyGraphDataProvider._();

final class WeeklyGraphDataProvider extends $FunctionalProvider<
    Map<String, List<int>>,
    Map<String, List<int>>,
    Map<String, List<int>>> with $Provider<Map<String, List<int>>> {
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

String _$weeklyGraphDataHash() => r'9e18e09a4b5deeffe8dfed4edffa8aa4fdd2ffa9';

@ProviderFor(historyGraphState)
final historyGraphStateProvider = HistoryGraphStateProvider._();

final class HistoryGraphStateProvider extends $FunctionalProvider<
    HistoryGraphState,
    HistoryGraphState,
    HistoryGraphState> with $Provider<HistoryGraphState> {
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

String _$historyGraphStateHash() => r'7a16417f7738dead655828c634b57853d332ecb8';
