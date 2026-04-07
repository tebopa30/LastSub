import 'package:flutter/material.dart';

/// 利用規約表示ページ
class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Text(
            '利用規約',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '本利用規約（以下「本規約」）は、本アプリ「LastSub」（以下「本アプリ」）の提供するサービスの利用条件を定めるものです。ユーザーの皆様は、本規約に従って本アプリをご利用ください。',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          const _Section(
            title: '1. 規約への同意',
            body:
                'ユーザーは、本アプリをインストールまたは利用することにより、本規約に同意したものとみなされます。'
                '本規約に同意できない場合は、本アプリの利用を中止してください。',
          ),

          const _Section(
            title: '2. サービスの提供',
            body:
                '本アプリは、タスクの間隔を記録し通知する機能を提供します。'
                '開発者は、予告なく本アプリの内容を変更、中断、または終了することができるものとします。',
          ),

          const _Section(
            title: '3. 知的財産権',
            body:
                '本アプリに関する著作権、商標権、その他一切の知的財産権は、開発者または正当な権利者に帰属します。'
                '本アプリ内のコンテンツを無断で複製、転載、改変することを禁止します。',
          ),

          const _Section(
            title: '4. 禁止事項',
            children: [
              '・本規約または法令に違反する行為',
              '・本アプリの運営を妨げる行為',
              '・本アプリを逆アセンブル、逆コンパイル、リバースエンジニアリングする行為',
              '・その他、開発者が不適切と判断する行為',
            ],
          ),

          const _Section(
            title: '5. 免責事項',
            body:
                '・本アプリは現状有姿で提供され、その正確性、完全性、特定の目的への適合性について明示的または黙示的な保証をしません。'
                '・本アプリの利用により生じた損害（データの消失、通知の遅延、端末の故障など）について、開発者は一切の責任を負いません。'
                '・広告配信などの第三者サービスによって生じた不利益についても責任を負わないものとします。',
          ),

          const _Section(
            title: '6. プレミアムプラン',
            body:
                '・プレミアムプランは、自動更新されるサブスクリプション方式で提供されます。'
                '・購入後のキャンセル、返金に関しては、各プラットフォーム（Google Play / App Store）のポリシーに従ってください。'
                '・購読停止（解約）を行わない限り、期間終了時に自動的に更新され課金が発生します。',
          ),

          const _Section(
            title: '7. 利用規約の変更',
            body:
                '開発者は、ユーザーへの事前の通知なく、本規約を変更できるものとします。'
                '変更後の規約は、本アプリ内に掲載された時点より効力を生じるものとします。',
          ),

          const _Section(
            title: '8. 準拠法・管轄裁判所',
            body:
                '本規約の解釈および適用は、日本法に準拠するものとします。'
                '本アプリに関して紛争が生じた場合は、東京地方裁判所を第一審の専属的合意管轄裁判所とします。',
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
