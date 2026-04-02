import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../domain/interval_analysis_result.dart';
import '../domain/task_record_entity.dart';

part 'interval_analysis_provider.g.dart';

/// バックエンドAPIのエンドポイント
/// 本番用は --dart-define=ANALYZE_BASE_URL=https://... で指定可能
const _kAnalyzeBaseUrl = String.fromEnvironment(
  'ANALYZE_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// 簡易インメモリキャッシュ（API連続呼び出し防止用）
/// アプリ起動中のみ保持。キーは taskId
final _analysisCache = <String, IntervalAnalysisResult>{};

/// タスクIDごとに次回実施予測を取得するFamilyプロバイダ。
/// - SQLiteから過去30日間のレコードを取得
/// - バックエンドの /api/v1/analyze にPOSTして結果を返す
/// - 2件未満のデータ、UID未取得、通信エラー等の場合は null を返す（UI側で静かに非表示）
@riverpod
Future<IntervalAnalysisResult?> intervalAnalysis(
  Ref ref,
  String taskId, {
  String? taskTitle,
}) async {
  // 1. キャッシュ確認 (一度取得に成功していればそれを返す。本番用簡易防護)
  if (_analysisCache.containsKey(taskId)) {
    return _analysisCache[taskId];
  }

  // 2. UID確認 (未ログイン時はAPIを呼ばず安全にnullリターン)
  final uid = ref.watch(currentUidProvider);
  if (uid == kLocalUserId) {
    debugPrint('[IntervalAnalysis] UID is null (local user). Skipping API call.');
    return null;
  }

  // 3. データ取得 (最低2件ないと予測できない)
  final repo = ref.watch(taskRecordRepositoryProvider);
  final since = DateTime.now().subtract(const Duration(days: 30));
  
  // fetchRecordsByPeriod 自体が失敗した場合もキャッチできるよう安全ガード
  List<TaskRecordEntity> records = [];
  try {
    records = await repo.fetchRecordsByPeriod(taskId, since, DateTime.now());
  } catch (e) {
    debugPrint('[IntervalAnalysis] Local DB error: $e');
    return null;
  }

  if (records.length < 2) return null;

  // 最新20件に絞る（過多なデータはノイズになりやすい）
  final limited = records.length > 20 ? records.sublist(records.length - 20) : records;

  final body = jsonEncode({
    'uid': uid,
    'taskId': taskId,
    'taskTitle': taskTitle,
    'records': limited.map((r) => {'recordedAt': r.recordedAt.toIso8601String()}).toList(),
  });

  // 4. API通信 (5秒タイムアウト, try/catch保護)
  try {
    final response = await http
        .post(
          Uri.parse('$_kAnalyzeBaseUrl/api/v1/analyze'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 5)); // 要件: 5秒タイムアウト

    if (response.statusCode == 200) {
      // 5. パース処理の保護
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final result = IntervalAnalysisResult.fromJson(json);
        // キャッシュに保存
        _analysisCache[taskId] = result;
        return result;
      } catch (parseError) {
        debugPrint('[IntervalAnalysis] JSON Parse error: $parseError');
        return null;
      }
    } else {
      debugPrint('[IntervalAnalysis] API status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // ネットワークエラー・タイムアウト・例外 → 完全に握りつぶし、UIクラッシュを防ぐ
    debugPrint('[IntervalAnalysis] Request failed: $e');
    return null;
  }
}
