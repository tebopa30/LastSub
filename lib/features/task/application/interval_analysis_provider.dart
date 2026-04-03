import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/interval_analysis_result.dart';

part 'interval_analysis_provider.g.dart';

/// AI 予測機能はローカル版では未使用。常に null を返すスタブ。
@riverpod
Future<IntervalAnalysisResult?> intervalAnalysis(
  Ref ref,
  String taskId, {
  String? taskTitle,
}) async {
  return null;
}
