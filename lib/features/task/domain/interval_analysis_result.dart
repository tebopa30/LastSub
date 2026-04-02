/// 区間分析の結果モデル。
/// バックエンド `AnalyzeResponse` のフィールドをそのままミラーリングする。
class IntervalAnalysisResult {
  final double averageIntervalMinutes;
  final double latestIntervalMinutes;
  final double differencePercent;
  final double estimatedNextMinutes;
  final String status;   // "short" | "normal" | "long"
  final String trend;    // "stable" | "getting_longer" | "getting_shorter"
  final String confidence; // "low" | "medium" | "high"
  final String urgency;    // "low" | "medium" | "high"
  final int dataPoints;
  final String primaryMessage;
  final String secondaryMessage;

  const IntervalAnalysisResult({
    required this.averageIntervalMinutes,
    required this.latestIntervalMinutes,
    required this.differencePercent,
    required this.estimatedNextMinutes,
    required this.status,
    required this.trend,
    required this.confidence,
    required this.urgency,
    required this.dataPoints,
    required this.primaryMessage,
    required this.secondaryMessage,
  });

  factory IntervalAnalysisResult.fromJson(Map<String, dynamic> json) {
    return IntervalAnalysisResult(
      averageIntervalMinutes: (json['averageIntervalMinutes'] as num).toDouble(),
      latestIntervalMinutes: (json['latestIntervalMinutes'] as num).toDouble(),
      differencePercent: (json['differencePercent'] as num).toDouble(),
      estimatedNextMinutes: (json['estimatedNextMinutes'] as num).toDouble(),
      status: json['status'] as String,
      trend: json['trend'] as String,
      confidence: json['confidence'] as String,
      urgency: json['urgency'] as String,
      dataPoints: json['dataPoints'] as int,
      primaryMessage: json['primaryMessage'] as String,
      secondaryMessage: json['secondaryMessage'] as String,
    );
  }
}
