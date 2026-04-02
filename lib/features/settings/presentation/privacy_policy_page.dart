import 'package:flutter/material.dart';

/// プライバシーポリシー表示ページ
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Text(
            'プライバシーポリシー',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '本アプリ「Itukara」（以下「本アプリ」）は、以下の通り個人情報を取り扱います。',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const _Section(
            title: '1. 取得する情報',
            children: [
              '・広告配信のための識別情報（Google AdMob）',
              '・アプリ利用状況データ',
            ],
          ),
          const _Section(
            title: '2. 利用目的',
            children: [
              '・サービス提供のため',
              '・広告配信のため',
              '・サービス改善のため',
            ],
          ),
          const _Section(
            title: '3. 広告について',
            body: '本アプリは Google AdMob を利用しています。広告配信事業者はユーザーの情報を利用する場合があります。',
          ),
          const _Section(
            title: '4. 外部送信について',
            body: '広告配信のため、第三者へ情報が送信されることがあります。',
          ),
          const _Section(
            title: '5. お問い合わせ',
            body: 'お問い合わせはメールアドレス tebopa30@gmail.com までお願いいたします。',
          ),
          const _Section(
            title: '6. 利用規約',
            body: '本アプリの利用規約は https://tebopa30.github.io/itukara_terms/terms.html をご覧ください。',
          ),
          const _Section(
            title: '7. Googleの広告に関する詳細',
            body: 'Googleの広告に関する詳細は https://policies.google.com/technologies/ads をご覧ください。',
          ),
          const Divider(height: 32),
          Text(
            '制定日：2026年3月',
            style: textTheme.bodySmall?.copyWith(color: cs.outline),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? body;
  final List<String>? children;

  const _Section({required this.title, this.body, this.children});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (body != null)
            Text(body!, style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          if (children != null)
            ...children!.map((item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item, style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                )),
        ],
      ),
    );
  }
}
