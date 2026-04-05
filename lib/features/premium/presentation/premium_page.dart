import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/premium_provider.dart';
import '../../../core/providers/purchase_provider.dart';

class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final purchaseAsync = ref.watch(purchaseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── ヘッダー ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF001F26), const Color(0xFF003A42)]
                        : [const Color(0xFF006064), const Color(0xFF00ACC1)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5),
                        ),
                        child: const Icon(Icons.workspace_premium,
                            color: Colors.white, size: 38),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'LastSub Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'すべての機能を制限なく使う',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 特典リスト ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (isPremium) ...[
                  _ActiveBadge(cs: cs),
                  const SizedBox(height: 24),
                ],

                Text(
                  'プレミアムの特典',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: isDark ? 1.5 : 0,
                      ),
                ),
                const SizedBox(height: 16),

                _BenefitCard(
                  icon: Icons.block,
                  iconColor: const Color(0xFF00BCD4),
                  title: '広告を非表示',
                  description: '画面下部のバナー広告が非表示になり、すっきりとした画面でご利用いただけます。',
                  isDark: isDark,
                ),
                _BenefitCard(
                  icon: Icons.add_task,
                  iconColor: const Color(0xFF4CAF50),
                  title: 'タスク上限 15件',
                  description: '無料プランの5件制限がなくなり、最大15件のタスクを管理できます。',
                  isDark: isDark,
                ),
                _BenefitCard(
                  icon: Icons.picture_as_pdf_outlined,
                  iconColor: const Color(0xFFFF7043),
                  title: 'PDF エクスポート',
                  description: '記録履歴を PDF として出力・共有できます。データのバックアップや共有に便利です。',
                  isDark: isDark,
                ),
                _BenefitCard(
                  icon: Icons.history_outlined,
                  iconColor: const Color(0xFF9C27B0),
                  title: '全期間の履歴表示',
                  description: '7日・30日の制限なく、記録したすべての履歴を閲覧できます。',
                  isDark: isDark,
                ),

                const SizedBox(height: 32),

                // ── 購入 / 有効中 ボタン ──────────────────────
                if (!isPremium) ...[
                  purchaseAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => _UnavailableMessage(cs: cs),
                    data: (purchaseState) {
                      switch (purchaseState.status) {
                        case IAPStatus.unavailable:
                          return _UnavailableMessage(cs: cs);
                        case IAPStatus.purchasing:
                          return const Center(
                              child: CircularProgressIndicator());
                        case IAPStatus.error:
                          return Column(
                            children: [
                              _ErrorMessage(
                                  message: purchaseState.errorMessage ??
                                      '購入処理中にエラーが発生しました',
                                  cs: cs),
                              const SizedBox(height: 12),
                              _UpgradeButton(
                                  ref: ref,
                                  isDark: isDark,
                                  productDetails: purchaseState.productDetails),
                            ],
                          );
                        case IAPStatus.loading:
                        case IAPStatus.ready:
                          return _UpgradeButton(
                              ref: ref,
                              isDark: isDark,
                              productDetails: purchaseState.productDetails);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => ref
                          .read(purchaseProvider.notifier)
                          .restorePurchases(),
                      child: Text(
                        '購入を復元する',
                        style: TextStyle(fontSize: 13, color: cs.outline),
                      ),
                    ),
                  ),
                ] else ...[
                  if (kDebugMode) _DowngradeButton(ref: ref, cs: cs),
                ],

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── プレミアム有効中バッジ ─────────────────────────────────
class _ActiveBadge extends StatelessWidget {
  final ColorScheme cs;
  const _ActiveBadge({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00BCD4).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.4), width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF00BCD4), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'プレミアムプランをご利用中です',
              style: TextStyle(
                color: Color(0xFF00BCD4),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 特典カード ────────────────────────────────────────────
class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool isDark;

  const _BenefitCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: isDark ? 0.6 : 1.0),
        borderRadius: BorderRadius.circular(isDark ? 4 : 16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2A2A2A)
              : cs.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(isDark ? 4 : 12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 13, color: cs.onSurfaceVariant, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── アップグレードボタン ─────────────────────────────────
class _UpgradeButton extends StatelessWidget {
  final WidgetRef ref;
  final bool isDark;
  final dynamic productDetails; // ProductDetails?

  const _UpgradeButton(
      {required this.ref, required this.isDark, this.productDetails});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: const Icon(Icons.workspace_premium, size: 20),
        label: const Text(
          'プレミアムへアップグレード (¥200/月)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor:
              isDark ? const Color(0xFF00BCD4) : const Color(0xFF006064),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDark ? 4 : 16),
          ),
        ),
        onPressed: productDetails == null
            ? null
            : () => ref.read(purchaseProvider.notifier).buyPremium(),
      ),
    );
  }
}

// ── 購入不可メッセージ ─────────────────────────────────
class _UnavailableMessage extends StatelessWidget {
  final ColorScheme cs;
  const _UnavailableMessage({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '現在この端末では購入できません。\nGoogle Play / App Store が利用可能な状態でお試しください。',
        style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── エラーメッセージ ─────────────────────────────────
class _ErrorMessage extends StatelessWidget {
  final String message;
  final ColorScheme cs;
  const _ErrorMessage({required this.message, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 12, color: cs.error),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── ダウングレードボタン（テスト用）──────────────────────
class _DowngradeButton extends StatelessWidget {
  final WidgetRef ref;
  final ColorScheme cs;
  const _DowngradeButton({required this.ref, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await ref.read(isPremiumProvider.notifier).setPremium(false);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('無料プランに戻しました')),
            );
            Navigator.pop(context);
          }
        },
        child:
            Text('無料プランに戻す', style: TextStyle(color: cs.outline, fontSize: 13)),
      ),
    );
  }
}
