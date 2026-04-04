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
            '本アプリ「LastSub」（以下「本アプリ」）は、ユーザーのプライバシーを尊重し、以下の方針に基づいて個人情報を取り扱います。',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          const _Section(
            title: '1. 収集する情報',
            children: [
              '・広告配信のための端末識別情報（Google AdMob による）',
              '・アプリの利用状況データ（クラッシュレポートなど）',
            ],
          ),

          const _Section(
            title: '2. 収集しない情報',
            body:
                '本アプリが記録するタスク履歴・設定情報はすべてお使いの端末内にのみ保存されます。'
                '氏名・メールアドレス・位置情報などの個人を特定できる情報は一切収集しません。',
          ),

          const _Section(
            title: '3. 情報の利用目的',
            children: [
              '・本アプリのサービス提供および機能改善のため',
              '・広告配信のため（無料プランのみ）',
              '・アプリの安定性向上・不具合の調査のため',
            ],
          ),

          const _Section(
            title: '4. 広告について',
            body:
                '本アプリの無料プランでは Google AdMob による広告を表示しています。'
                'AdMob はユーザーの興味・関心に基づいた広告を配信するため、端末の広告識別子等を利用する場合があります。'
                '広告のパーソナライズ設定は端末の設定画面から変更できます。\n\n'
                'Google のプライバシーポリシー：\n'
                'https://policies.google.com/privacy\n\n'
                'Google AdMob の広告に関する詳細：\n'
                'https://policies.google.com/technologies/ads',
          ),

          const _Section(
            title: '5. 第三者への情報提供',
            body:
                '本アプリは法令に基づく場合を除き、収集した情報を第三者に提供・販売することはありません。'
                'ただし広告配信のため、Google AdMob に端末識別情報が送信される場合があります。',
          ),

          const _Section(
            title: '6. プレミアムプランについて',
            body:
                'プレミアムプランのご購入は Google Play の課金システムを通じて行われます。'
                '決済情報は Google Play が管理するものであり、本アプリは決済情報を収集・保存しません。',
          ),

          const _Section(
            title: '7. ローカル通知について',
            body:
                '本アプリはタスクの推奨間隔およびアラートタイマーのためにローカル通知機能を使用します。'
                '通知は端末内でのみ処理され、外部サーバーへのデータ送信は行いません。',
          ),

          const _Section(
            title: '8. プライバシーポリシーの変更',
            body:
                '本ポリシーの内容は、必要に応じて予告なく変更される場合があります。'
                '変更後のポリシーはアプリ内の本画面に掲載した時点から効力を生じます。',
          ),

          const _Section(
            title: '9. お問い合わせ',
            body: '本ポリシーに関するご質問・ご意見は下記までお問い合わせください。\n\nメール：tebopa30@gmail.com',
          ),

          const Divider(height: 32),
          Text(
            '制定日：2026年4月',
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
            Text(body!,
                style: textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant, height: 1.6)),
          if (children != null)
            ...children!.map((item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant, height: 1.6)),
                )),
        ],
      ),
    );
  }
}
