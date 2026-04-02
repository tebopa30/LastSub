import 'package:flutter/material.dart';

// 利用可能なカスタムアイコン
final Map<String, IconData> availableIcons = {
  'baby_changing_station': Icons.baby_changing_station,
  'local_drink': Icons.local_drink,
  'bedtime': Icons.bedtime,
  'bathtub': Icons.bathtub,
  'cleaning_services': Icons.cleaning_services,
  'child_care': Icons.child_care,
  'stroller': Icons.stroller,
  'medication': Icons.medication,
  'restaurant': Icons.restaurant,
  'favorite': Icons.favorite,
};

// 利用可能なパステルカラーセット（[背景色, アイコン色]）
final Map<String, List<Color>> availableColors = {
  'yellow': [const Color(0xFFFFF9C4), const Color(0xFFF57F17)],
  'blue': [const Color(0xFFB3E5FC), const Color(0xFF0277BD)],
  'purple': [const Color(0xFFD1C4E9), const Color(0xFF4527A0)],
  'cyan': [const Color(0xFFB2EBF2), const Color(0xFF00838F)],
  'green': [const Color(0xFFC8E6C9), const Color(0xFF2E7D32)],
  'pink': [const Color(0xFFF8BBD0), const Color(0xFFC2185B)],
  'orange': [const Color(0xFFFFE0B2), const Color(0xFFE65100)],
};

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

TaskDesignInfo getTaskDesignInfo(String title, {String? iconName, String? colorCode}) {
  // DB等に保存されたiconNameとcolorCodeがあればそれを優先
  if (iconName != null && colorCode != null) {
    final icon = availableIcons[iconName] ?? Icons.check_circle_outline;
    final colors = availableColors[colorCode] ?? [const Color(0xFFF5F5F5), const Color(0xFF616161)];
    return TaskDesignInfo(
      iconData: icon,
      backgroundColor: colors[0],
      iconColor: colors[1],
    );
  }

  // デフォルトタスクのタイトルベース判定
  switch (title) {
    case 'オムツ替え':
    case 'オムツ替え（うんち）':
    case 'オムツ替え（おしっこ）':
      return TaskDesignInfo(
        iconData: availableIcons['baby_changing_station']!,
        backgroundColor: availableColors['yellow']![0],
        iconColor: availableColors['yellow']![1],
      );
    case 'ミルク':
      return TaskDesignInfo(
        iconData: availableIcons['local_drink']!,
        backgroundColor: availableColors['blue']![0],
        iconColor: availableColors['blue']![1],
      );
    case '睡眠':
      return TaskDesignInfo(
        iconData: availableIcons['bedtime']!,
        backgroundColor: availableColors['purple']![0],
        iconColor: availableColors['purple']![1],
      );
    case 'お風呂':
      return TaskDesignInfo(
        iconData: availableIcons['bathtub']!,
        backgroundColor: availableColors['cyan']![0],
        iconColor: availableColors['cyan']![1],
      );
    case '哺乳瓶消毒':
      return TaskDesignInfo(
        iconData: availableIcons['cleaning_services']!,
        backgroundColor: availableColors['green']![0],
        iconColor: availableColors['green']![1],
      );
    case '母乳　右':
    case '母乳　左':
      return TaskDesignInfo(
        iconData: availableIcons['child_care']!,
        backgroundColor: availableColors['pink']![0],
        iconColor: availableColors['pink']![1],
      );
    default:
      return const TaskDesignInfo(
        iconData: Icons.check_circle_outline,
        backgroundColor: Color(0xFFF5F5F5), // Grey 100
        iconColor: Color(0xFF616161), // Grey 700
      );
  }
}
