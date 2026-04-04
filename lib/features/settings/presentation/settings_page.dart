import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import 'privacy_policy_page.dart';
import 'user_manual_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isClassicSleek = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
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

          // ── 通知 ──
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('推奨間隔通知'),
            subtitle: Text(
              'タスクカードで推奨間隔を設定すると、前回の記録から設定時間が経過した際に通知が届きます。'
              'スリープ中でも通知されます。',
            ),
            isThreeLine: true,
          ),

          const Divider(),

          // ── ヘルプ ──
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('使い方'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManualPage()),
            ),
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
