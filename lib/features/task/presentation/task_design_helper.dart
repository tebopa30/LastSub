import 'package:flutter/material.dart';

// ── アイコンセット（育児 + 汎用）──────────────────────────────────────
final Map<String, IconData> availableIcons = {
  // 育児・健康
  'baby_changing_station': Icons.baby_changing_station,
  'local_drink':           Icons.local_drink,
  'bedtime':               Icons.bedtime,
  'bathtub':               Icons.bathtub,
  'cleaning_services':     Icons.cleaning_services,
  'child_care':            Icons.child_care,
  'stroller':              Icons.stroller,
  'medication':            Icons.medication,
  'restaurant':            Icons.restaurant,
  'favorite':              Icons.favorite,
  // 運動・スポーツ
  'directions_run':        Icons.directions_run,
  'fitness_center':        Icons.fitness_center,
  'self_improvement':      Icons.self_improvement,
  'sports_soccer':         Icons.sports_soccer,
  'spa':                   Icons.spa,
  // 日常生活
  'home':                  Icons.home,
  'work':                  Icons.work,
  'school':                Icons.school,
  'shopping_cart':         Icons.shopping_cart,
  'directions_car':        Icons.directions_car,
  // 趣味・エンタメ
  'local_library':         Icons.local_library,
  'music_note':            Icons.music_note,
  'pets':                  Icons.pets,
  'coffee':                Icons.coffee,
  'celebration':           Icons.celebration,
  // タスク管理
  'timer':                 Icons.timer,
  'alarm':                 Icons.alarm,
  'note_alt':              Icons.note_alt,
  'psychology':            Icons.psychology,
  'check_circle':          Icons.check_circle,
};

// ── Natural Soft カラーパレット（パステル背景 × 深みある差し色）────────
final Map<String, List<Color>> availableColorsNatural = {
  'yellow': [const Color(0xFFFFF9C4), const Color(0xFFF57F17)],
  'blue':   [const Color(0xFFBBDEFB), const Color(0xFF1565C0)],
  'purple': [const Color(0xFFD1C4E9), const Color(0xFF4527A0)],
  'cyan':   [const Color(0xFFB2EBF2), const Color(0xFF006064)],
  'green':  [const Color(0xFFC8E6C9), const Color(0xFF1B5E20)],
  'pink':   [const Color(0xFFF8BBD0), const Color(0xFF880E4F)],
  'orange': [const Color(0xFFFFE0B2), const Color(0xFFBF360C)],
  'rose':   [const Color(0xFFFFCDD2), const Color(0xFFB71C1C)],
  'teal':   [const Color(0xFFB2DFDB), const Color(0xFF004D40)],
  'indigo': [const Color(0xFFC5CAE9), const Color(0xFF1A237E)],
  'lime':   [const Color(0xFFF0F4C3), const Color(0xFF33691E)],
  'brown':  [const Color(0xFFD7CCC8), const Color(0xFF3E2723)],
};

// ── Classic Sleek カラーパレット（極暗背景 × ネオンアクセント）─────────
final Map<String, List<Color>> availableColorsSleek = {
  'yellow': [const Color(0xFF1C1800), const Color(0xFFFFD600)],
  'blue':   [const Color(0xFF00102A), const Color(0xFF40C4FF)],
  'purple': [const Color(0xFF12001F), const Color(0xFFD500F9)],
  'cyan':   [const Color(0xFF00181F), const Color(0xFF00E5FF)],
  'green':  [const Color(0xFF001500), const Color(0xFF69F0AE)],
  'pink':   [const Color(0xFF1F000E), const Color(0xFFFF4081)],
  'orange': [const Color(0xFF1F0B00), const Color(0xFFFF9100)],
  'rose':   [const Color(0xFF1F0005), const Color(0xFFFF1744)],
  'teal':   [const Color(0xFF001412), const Color(0xFF1DE9B6)],
  'indigo': [const Color(0xFF07091A), const Color(0xFF7986CB)],
  'lime':   [const Color(0xFF111A00), const Color(0xFFCCFF90)],
  'brown':  [const Color(0xFF150D08), const Color(0xFFBCAAA4)],
};

// 後方互換エイリアス
final Map<String, List<Color>> availableColors = availableColorsNatural;

// ── デザイン情報 ─────────────────────────────────────────────────────
class TaskDesignInfo {
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;

  const TaskDesignInfo({
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
  });
}

TaskDesignInfo getTaskDesignInfo(
  String title, {
  String? iconName,
  String? colorCode,
  bool isDark = false,
}) {
  final colorMap = isDark ? availableColorsSleek : availableColorsNatural;
  final defaultColors = isDark
      ? [const Color(0xFF1A1A1A), const Color(0xFF888888)]
      : [const Color(0xFFF5F5F5), const Color(0xFF616161)];

  if (iconName != null && colorCode != null) {
    final icon = availableIcons[iconName] ?? Icons.check_circle_outline;
    final colors = colorMap[colorCode] ?? defaultColors;
    return TaskDesignInfo(
      iconData: icon,
      backgroundColor: colors[0],
      iconColor: colors[1],
    );
  }

  return TaskDesignInfo(
    iconData: Icons.check_circle_outline,
    backgroundColor: defaultColors[0],
    iconColor: defaultColors[1],
  );
}
