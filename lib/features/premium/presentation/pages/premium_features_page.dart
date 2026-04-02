import 'package:flutter/material.dart';

/// プレミアム機能の詳細説明ページ
class PremiumFeaturesPage extends StatelessWidget {
  const PremiumFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアム機能について'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: Icon(
              Icons.star,
              size: 64,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'プレミアムプランでできること',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),
          const _FeatureItem(
            icon: Icons.add_circle_outline,
            title: 'タスクを最大15項目まで追加',
            description: 'デフォルトの8項目に加え、最大15項目まで自由にタスクを追加・カスタマイズできます。',
          ),
          const _FeatureItem(
            icon: Icons.sync,
            title: 'クラウド同期',
            description: '複数端末間でデータを同期できます。機種変更時もデータを引き継げます。',
          ),
          const _FeatureItem(
            icon: Icons.block,
            title: '広告非表示',
            description: '広告なしで快適にご利用いただけます。',
          ),
          const _FeatureItem(
            icon: Icons.new_releases_outlined,
            title: '今後の機能を優先提供',
            description: '新機能はプレミアム会員に優先的に提供されます。',
          ),
          const SizedBox(height: 32),
          Text(
            '月額プランはいつでも解約可能です。\n（Apple ID / Google Play の設定より）',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
