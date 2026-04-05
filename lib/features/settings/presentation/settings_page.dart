import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/premium_provider.dart';
import '../../premium/presentation/premium_page.dart';
import 'privacy_policy_page.dart';
import 'user_manual_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isClassicSleek = themeMode == ThemeMode.dark;
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // ── プレミアムプラン ──
          ListTile(
            leading: Icon(
              Icons.workspace_premium,
              color: isPremium
                  ? const Color(0xFF00BCD4)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(isPremium ? 'プレミアムプラン（有効中）' : 'プレミアムプランを見る'),
            subtitle: Text(
              isPremium ? '広告非表示・タスク15件・PDF出力が有効です' : '広告非表示・タスク上限拡張・PDF出力',
              style: TextStyle(
                  fontSize: 12,
                  color: isPremium
                      ? const Color(0xFF00BCD4)
                      : Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PremiumPage()),
            ),
          ),

          const Divider(),

          // ── テーマ設定 ──
          const ListTile(
            title: Text('テーマ'),
            subtitle: Text('アプリのデザインを切り替えます'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _ThemeCard(
                    label: 'Natural Soft',
                    description: '白・ベージュ・淡いグリーンの優しいデザイン',
                    icon: Icons.eco_outlined,
                    isSelected: !isClassicSleek,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(AppThemeType.naturalSoft),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThemeCard(
                    label: 'Classic Sleek',
                    description: '黒・ダークグレー・細いフォントのミニマリスト',
                    icon: Icons.nightlight_outlined,
                    isSelected: isClassicSleek,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(AppThemeType.classicSleek),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // ── ヘルプ ──
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('アプリガイド'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManualPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('チュートリアルを再表示'),
            subtitle: const Text('使い方のガイドをもう一度表示します'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('tutorial_shown', false);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('次回アプリを開いたときにチュートリアルが表示されます')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
            ),
          ),

          const Divider(),

          // ── アプリ情報 ──
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('バージョン'),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            Theme.of(context).brightness == Brightness.dark ? 4 : 16,
          ),
          border: Border.all(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? cs.primary : cs.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? cs.primary : cs.onSurface,
                )),
            const SizedBox(height: 4),
            Text(description,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurfaceVariant,
                )),
          ],
        ),
      ),
    );
  }
}
