/// 今日1日の育児統計サマリ
class DailyStatsModel {
  /// カテゴリごとの値（回数 または 分数）
  /// キー: タスク名 (e.g. "ミルク", "オムツ替え", "睡眠")
  final Map<String, double> categoryValues;

  /// 集計対象日（その日の 00:00:00）
  final DateTime date;

  const DailyStatsModel({
    required this.categoryValues,
    required this.date,
  });

  /// 空の統計（初期値）
  factory DailyStatsModel.empty(DateTime date) => DailyStatsModel(
        categoryValues: {},
        date: date,
      );

  /// 特定のカテゴリの値を取得（デフォルト 0）
  double getValue(String category) => categoryValues[category] ?? 0;

  /// 簡易取得用
  int get milkCount => getValue('ミルク').toInt();
  int get diaperCount => getValue('オムツ').toInt();
  double get sleepMinutes => getValue('睡眠');

  /// 睡眠時間を時間と分で返すヘルパー
  String get sleepFormatted {
    final mins = sleepMinutes;
    final h = mins ~/ 60;
    final m = (mins % 60).toInt();
    if (h > 0) return '$h時間$m分';
    return '$m分';
  }

  @override
  String toString() =>
      'DailyStatsModel(date:$date, values:$categoryValues)';
}
