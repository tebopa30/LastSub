// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AI 予測機能はローカル版では未使用。常に null を返すスタブ。

@ProviderFor(intervalAnalysis)
final intervalAnalysisProvider = IntervalAnalysisFamily._();

/// AI 予測機能はローカル版では未使用。常に null を返すスタブ。

final class IntervalAnalysisProvider extends $FunctionalProvider<
        AsyncValue<IntervalAnalysisResult?>,
        IntervalAnalysisResult?,
        FutureOr<IntervalAnalysisResult?>>
    with
        $FutureModifier<IntervalAnalysisResult?>,
        $FutureProvider<IntervalAnalysisResult?> {
  /// AI 予測機能はローカル版では未使用。常に null を返すスタブ。
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

String _$intervalAnalysisHash() => r'dd2f2e48016291f6f85dbbed7eac4860594676db';

/// AI 予測機能はローカル版では未使用。常に null を返すスタブ。

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

  /// AI 予測機能はローカル版では未使用。常に null を返すスタブ。

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
