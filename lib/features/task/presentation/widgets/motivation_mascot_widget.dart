import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../application/motivation_provider.dart';

class MotivationMascotWidget extends ConsumerWidget {
  const MotivationMascotWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(motivationProvider);
    final health = ref.watch(globalHealthProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 状態に応じたLottieファイルとメッセージの出し分け
    String lottieAsset = 'assets/lottie/mascot_happy.json';
    String message = '';
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.black;

    switch (health) {
      case GlobalHealth.excellent:
        lottieAsset = 'assets/lottie/mascot_happy.json';
        message = '完璧だね！ピカピカだよ✨';
        backgroundColor = isDark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E9);
        textColor = isDark ? Colors.white : const Color(0xFF2E7D32);
        break;
      case GlobalHealth.good:
        lottieAsset = 'assets/lottie/mascot_happy.json';
        message = '今日もいい感じ！';
        backgroundColor = isDark ? const Color(0xFFE65100).withValues(alpha: 0.3) : const Color(0xFFFFF3E0);
        textColor = isDark ? Colors.orange.shade100 : const Color(0xFFE65100);
        break;
      case GlobalHealth.warning:
        lottieAsset = 'assets/lottie/mascot_sad.json';
        message = 'そろそろお掃除したいな…';
        backgroundColor = isDark ? const Color(0xFF4E342E) : const Color(0xFFEFEBE9);
        textColor = isDark ? Colors.brown.shade100 : const Color(0xFF5D4037);
        break;
      case GlobalHealth.critical:
        lottieAsset = 'assets/lottie/mascot_sad.json';
        message = 'もう限界…助けて…😭';
        backgroundColor = isDark ? const Color(0xFFB71C1C).withValues(alpha: 0.4) : const Color(0xFFFFEBEE);
        textColor = isDark ? Colors.red.shade100 : const Color(0xFFC62828);
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // キャラクター (Lottie)
          SizedBox(
            width: 80,
            height: 80,
            child: Lottie.asset(
              lottieAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Lottieファイルが見つからない場合のフォールバック（初期実装時やファイル差し替え前の対策）
                return Icon(
                  health == GlobalHealth.critical || health == GlobalHealth.warning 
                    ? Icons.sentiment_very_dissatisfied 
                    : Icons.sentiment_very_satisfied,
                  size: 48,
                  color: textColor,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // メッセージとステータス
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 吹き出し風のメッセージ
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                // ポイント表示
                Row(
                  children: [
                    Icon(Icons.stars, size: 16, color: textColor.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      '${state.points} pt',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
