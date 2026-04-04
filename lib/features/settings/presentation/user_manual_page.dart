import 'package:flutter/material.dart';

class UserManualPage extends StatelessWidget {
  const UserManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('使い方マニュアル'),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.lock_open), text: '無料プラン'),
              Tab(icon: Icon(Icons.star), text: 'プレミアム'),
            ],
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _FreeManualTab(),
            _PremiumManualTab(),
          ],
        ),
      ),
    );
  }
}

// ── 無料プランタブ ────────────────────────────────────────────────────────────

class _FreeManualTab extends StatelessWidget {
  const _FreeManualTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionHeader(title: 'アプリのコンセプト'),
        _ManualItem(
          icon: Icons.hourglass_empty,
          iconColor: Colors.blueGrey,
          title: '「前回からどれくらい経ったか」を可視化する',
          body: 'LastSub は「前回の記録完了からの経過時間」を大きく表示するアプリです。\n\n'
              'タスクカードの大きな数字は常に「前回の完了時刻」からカウントしています。'
              '推奨間隔を設定すると色が変わり、適切なタイミングを一目で確認できます。',
        ),
        _SectionHeader(title: 'タスクの基本操作'),
        _ManualItem(
          icon: Icons.play_arrow,
          iconColor: Colors.green,
          title: '「開始」ボタン — 実行時間の計測を始める',
          body: 'タスクの実行を開始するときにタップします。カード上に「計測中: HH:MM」が表示され、実行時間を計り始めます。\n\n'
              '⚠️ この時点では経過時間の大きな表示は変わりません。「前回完了からの時間」は次に「完了」するまで更新されません。',
        ),
        _ManualItem(
          icon: Icons.check_circle,
          iconColor: Colors.teal,
          title: '「完了」ボタン — 記録を保存し、次のサイクルを開始する',
          body: '「完了」ボタンをタップすると確認ダイアログが表示されます。「記録」を選ぶと：\n'
              '• 開始〜完了の実行時間が履歴に保存されます\n'
              '• 完了時刻が「前回完了」として設定され、大きな経過時間がゼロからカウントを再開します\n\n'
              '【数値を記録する】\n'
              '完了ダイアログ内の「数値を記録する」をオンにすると、量や回数などを単位付きで一緒に保存できます（ml・g・cm・回 など）。',
        ),
        _ManualItem(
          icon: Icons.timer_outlined,
          iconColor: Colors.deepOrange,
          title: 'アラートタイマー機能',
          body: 'タスクカードで「開始」を押す前に「○分でアラート」を設定できます。\n\n'
              '開始後は残り時間（MM:SS）がカード上に表示され、設定時間が経過するとアラートダイアログで通知されます。',
        ),
        _ManualItem(
          icon: Icons.notifications_outlined,
          iconColor: Colors.indigo,
          title: '推奨間隔通知',
          body: 'タスクカードの右上チップから「推奨間隔」を設定すると、前回完了から設定時間が経過した際にプッシュ通知が届きます。\n\n'
              'スリープ中でも通知が届くため、タスクのやり忘れを防げます。',
        ),
        _ManualItem(
          icon: Icons.undo,
          iconColor: Colors.orange,
          title: '開始を取り消したい場合',
          body: '誤って「開始」を押してしまった場合は、そのまま放置するか、再度「開始」を押すとセッションが上書きされます。\n\n'
              '履歴画面から不要な記録を左スワイプで削除することも可能です。',
        ),
        _ManualItem(
          icon: Icons.drag_handle,
          iconColor: Colors.grey,
          title: 'タスクの順番を並び替える',
          body: 'カードを長押ししたままドラッグすると、タスクの表示順を変更できます。',
        ),
        _ManualItem(
          icon: Icons.add_circle_outline,
          iconColor: Colors.green,
          title: 'タスクを追加・削除する',
          body: '右下の「＋」ボタンからタスクを追加できます（無料プランは最大5件）。\n\n'
              'タスクカードを左スワイプすると削除できます。削除前に確認ダイアログが表示されます。',
        ),
        _SectionHeader(title: '履歴・グラフ'),
        _ManualItem(
          icon: Icons.history,
          iconColor: Colors.orange,
          title: '過去の記録を確認する',
          body: '上部メニューの「時計」アイコンをタップすると履歴画面が開きます。日付・タスクごとにまとめて確認できます。\n\n'
              '表示期間は「7日間」「30日間」から選択できます。',
        ),
        _ManualItem(
          icon: Icons.bar_chart,
          iconColor: Colors.purple,
          title: 'グラフで推移を確認する',
          body: '履歴画面上部のグラフから、タスク実施回数の推移をスタック棒グラフで確認できます。',
        ),
        _ManualItem(
          icon: Icons.delete_sweep,
          iconColor: Colors.red,
          title: '記録を削除する',
          body: '履歴画面の各記録を左スワイプすると削除できます。',
        ),
      ],
    );
  }
}

// ── プレミアムタブ ────────────────────────────────────────────────────────────

class _PremiumManualTab extends StatelessWidget {
  const _PremiumManualTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionHeader(title: 'タスク上限の拡張'),
        _ManualItem(
          icon: Icons.add_circle,
          iconColor: Colors.green,
          title: 'タスクを最大15件まで追加',
          body: '無料プランでは最大5件までのタスクを追加できますが、プレミアムプランでは最大15件まで追加できます。\n\n'
              'タスク名・アイコン（31種類）・テーマカラー（12色）を自由に組み合わせられます。',
        ),
        _SectionHeader(title: '履歴の拡張表示'),
        _ManualItem(
          icon: Icons.history_toggle_off,
          iconColor: Colors.orange,
          title: '全期間の履歴を表示',
          body: '履歴画面の期間選択で「全期間」が選択できるようになります。\n\n'
              '無料プランでは「7日間」「30日間」のみ表示可能です。',
        ),
        _ManualItem(
          icon: Icons.picture_as_pdf_outlined,
          iconColor: Colors.red,
          title: '履歴をPDFで出力・共有',
          body: '履歴画面の右上に「PDF出力」ボタンが表示されます。タップすると、表示中の期間のタスク実行履歴をPDFファイルとして保存・共有できます。\n\n'
              '記録時刻・開始時刻・経過時間・数値が表形式でまとめられます。',
        ),
        _SectionHeader(title: 'その他'),
        _ManualItem(
          icon: Icons.block,
          iconColor: Colors.grey,
          title: '広告の非表示',
          body: 'プレミアム加入中は画面下部の広告バナーが表示されなくなります。',
        ),
      ],
    );
  }
}

// ── 共通ウィジェット ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _ManualItem extends StatelessWidget {
  const _ManualItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
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
