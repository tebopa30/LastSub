import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/premium_status_notifier.dart';
import '../application/subscription_service.dart';

/// プレミアムプラン購入・管理用画面
class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumStatusAsync = ref.watch(premiumStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
      ),
      body: premiumStatusAsync.when(
        data: (entity) {
          if (entity.isPremium) {
            return _buildPremiumUserUi(context);
          } else {
            return _buildFreeUserUi(context, ref, entity.isLoading, entity.errorMessage);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
      ),
    );
  }

  Widget _buildPremiumUserUi(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 80),
            const SizedBox(height: 24),
            Text(
              'プレミアム機能が有効です！',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            _buildFeatureItem(context, Icons.block, '広告の完全削除'),
            _buildFeatureItem(context, Icons.edit_note, 'タスクの自由な追加・編集'),
            _buildFeatureItem(context, Icons.insights, 'AIによる育児傾向分析'),
            const SizedBox(height: 48),
            Text(
              'いつも「いつから」をご利用いただき\nありがとうございます。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeUserUi(BuildContext context, WidgetRef ref, bool isLoading, String? errorMessage) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              'プレミアムプランで\n育児をより快適に',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildFeatureItem(context, Icons.check_circle_outline, 'タスクを最大15項目まで追加・カスタマイズ'),
            _buildFeatureItem(context, Icons.check_circle_outline, 'クラウド同期による複数端末での利用'),
            _buildFeatureItem(context, Icons.check_circle_outline, '広告表示なし'),
            const SizedBox(height: 40),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => ref.read(subscriptionServiceProvider.notifier).buyMonthlySubscription(),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('プランに加入する', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(subscriptionServiceProvider.notifier).restorePurchase(),
                child: const Text('購入済みの方はこちら（復元）'),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              '月額プランはいつでも解約可能です。\n（Apple ID / Google Play の設定より）',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
