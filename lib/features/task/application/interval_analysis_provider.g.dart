// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
/// - SQLiteから過去30日間のレコードを取得
/// - バックエンドの /api/v1/analyze にPOSTして結果を返す
/// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）

@ProviderFor(intervalAnalysis)
final intervalAnalysisProvider = IntervalAnalysisFamily._();

/// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
/// - SQLiteから過去30日間のレコードを取得
/// - バックエンドの /api/v1/analyze にPOSTして結果を返す
/// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）

final class IntervalAnalysisProvider extends $FunctionalProvider<
        AsyncValue<IntervalAnalysisResult?>,
        IntervalAnalysisResult?,
        FutureOr<IntervalAnalysisResult?>>
    with
        $FutureModifier<IntervalAnalysisResult?>,
        $FutureProvider<IntervalAnalysisResult?> {
  /// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
  /// - SQLiteから過去30日間のレコードを取得
  /// - バックエンドの /api/v1/analyze にPOSTして結果を返す
  /// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）
  IntervalAnalysisProvider._(
      {required IntervalAnalysisFamily super.from,
      required (
        String, {
        String? taskTitle,
      })
          super.argument})
      : super(
          retry: null,
          name: r'intervalAnalysisProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$intervalAnalysisHash();

  @override
  String toString() {
    return r'intervalAnalysisProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<IntervalAnalysisResult?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<IntervalAnalysisResult?> create(Ref ref) {
    final argument = this.argument as (
      String, {
      String? taskTitle,
    });
    return intervalAnalysis(
      ref,
      argument.$1,
      taskTitle: argument.taskTitle,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IntervalAnalysisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$intervalAnalysisHash() => r'96e22c1bd31dc0f73afd4fbd160bbdacb646a038';

/// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
/// - SQLiteから過去30日間のレコードを取得
/// - バックエンドの /api/v1/analyze にPOSTして結果を返す
/// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）

final class IntervalAnalysisFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<IntervalAnalysisResult?>,
            (
              String, {
              String? taskTitle,
            })> {
  IntervalAnalysisFamily._()
      : super(
          retry: null,
          name: r'intervalAnalysisProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
  /// - SQLiteから過去30日間のレコードを取得
  /// - バックエンドの /api/v1/analyze にPOSTして結果を返す
  /// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）

  IntervalAnalysisProvider call(
    String taskId, {
    String? taskTitle,
  }) =>
      IntervalAnalysisProvider._(argument: (
        taskId,
        taskTitle: taskTitle,
      ), from: this);

  @override
  String toString() => r'intervalAnalysisProvider';
}
