import 'daily_stats_model.dart';

/// 過去7日間などの統計をまとめたモデル
class WeeklyStatsModel {
  /// 日ごとの統計リスト（日付順に並んでいることを想定）
  final List<DailyStatsModel> days;

  /// 全期間の合計カテゴリ値（サマリ用）
  final Map<String, double> totalValues;

  const WeeklyStatsModel({
    required this.days,
    required this.totalValues,
  });

  /// 空のモデル
  factory WeeklyStatsModel.empty() => const WeeklyStatsModel(
        days: [],
        totalValues: {},
      );

  bool get isEmpty => days.isEmpty;
}
