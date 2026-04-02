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
        _SectionHeader(title: '基本的な使い方'),
        _ManualItem(
          icon: Icons.play_arrow,
          iconColor: Colors.green,
          title: '「開始」ボタン — タイマーをスタートする（睡眠・母乳タスク）',
          body: '睡眠・母乳　右・母乳　左・カスタムタスクのカードには「開始」ボタンがあります。タップするとタイマーが始まり、経過時間がリアルタイムで表示されます。\n\n'
              '⚠️ この時点ではまだ履歴には記録されません。「記録」ボタンが表示されている状態です。\n\n'
              'ミルク・オムツ替え・哺乳瓶消毒・お風呂は「記録」ボタン1つのみで即時記録できます。',
        ),
        _ManualItem(
          icon: Icons.check_circle,
          iconColor: Colors.teal,
          title: '「記録」ボタン — 完了を履歴に保存する',
          body: '「記録」ボタンをタップすると確認ダイアログが表示されます。「はい」を選ぶと、そのタスクの実施記録が履歴に保存されます。\n\n'
              '保存後はタイマーがリセットされ、ボタンが再び「開始」に戻ります。次の作業に備えた状態です。\n\n'
              '【2ステップの目的】\n'
              '「開始」で作業の開始時刻を把握し、「記録」で完了を確定することで、いつ・何をしたかの正確な記録が残せます。例えばミルクをあげ終わってから「記録」を押すことで、次回の目安時刻の予測精度も上がります。',
        ),
        _ManualItem(
          icon: Icons.undo,
          iconColor: Colors.orange,
          title: 'タイマーをリセットしたい場合',
          body: '誤って「開始」を押してしまった場合でも、そのまま「記録」せずに放置しておくことができます。次回「開始」を押すと、タイマーは上書きされます。\n\n'
              '履歴画面から不要な記録を左スワイプで削除することも可能です。',
        ),
        _ManualItem(
          icon: Icons.opacity,
          iconColor: Colors.blue,
          title: 'ミルクの量を記録する',
          body: 'ミルクタスクのカード上にあるプルダウンで量（0〜500ml・10ml刻み）を選んでから「記録」ボタンを押してください。',
        ),
        _ManualItem(
          icon: Icons.child_care,
          iconColor: Colors.pink,
          title: '母乳タイマー機能',
          body: '「母乳　右」「母乳　左」のカードには、アラートを鳴らす時間（1〜20分）を選べるドロップダウンがあります。\n\n'
              '「開始」ボタンを押すとカウントダウンが始まり、カード上に残り時間（MM:SS）が表示されます。設定時間が経過するとアラートダイアログが表示されます。\n\n'
              '授乳完了後は「記録」ボタンで実施を保存してください（タイマーは自動で停止します）。',
        ),
        _ManualItem(
          icon: Icons.drag_handle,
          iconColor: Colors.grey,
          title: 'タスクの順番を並び替える',
          body: 'カードを長押ししたままドラッグすると、タスクの表示順を変更できます。',
        ),
        _SectionHeader(title: '履歴・グラフ'),
        _ManualItem(
          icon: Icons.history,
          iconColor: Colors.orange,
          title: '過去の記録を確認する',
          body: '上部メニューの「時計」アイコンをタップすると履歴画面が開きます。日付・タスクごとにまとめて確認できます。',
        ),
        _ManualItem(
          icon: Icons.bar_chart,
          iconColor: Colors.purple,
          title: '過去7日間のグラフ',
          body: '履歴画面のグラフアイコンから、過去7日間のタスク実施回数をスタック棒グラフで確認できます。',
        ),
        _ManualItem(
          icon: Icons.delete_sweep,
          iconColor: Colors.red,
          title: '記録を削除する',
          body: '履歴画面の各記録を左スワイプすると削除できます。',
        ),
        _SectionHeader(title: 'デフォルトタスク'),
        _ManualItem(
          icon: Icons.lock,
          iconColor: Colors.blueGrey,
          title: '削除できないタスク',
          body: 'ミルク・オムツ替え（うんち）・オムツ替え（おしっこ）・哺乳瓶消毒・睡眠・お風呂・母乳　右・母乳　左の8項目はデフォルトタスクです。スワイプ削除はできません。',
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
        _SectionHeader(title: 'カスタムタスク'),
        _ManualItem(
          icon: Icons.add_circle,
          iconColor: Colors.green,
          title: 'タスクを追加する',
          body: '右下の「＋タスク追加」ボタンをタップするとモーダルが開きます。タスク名・アイコン・テーマカラーを自由に設定できます（最大10件）。',
        ),
        _ManualItem(
          icon: Icons.swipe_left,
          iconColor: Colors.red,
          title: 'タスクを削除する',
          body: 'カスタムタスクは左スワイプで削除できます。削除前に確認ダイアログが表示されます。',
        ),
        _SectionHeader(title: 'クラウド同期'),
        _ManualItem(
          icon: Icons.account_circle,
          iconColor: Colors.blue,
          title: 'Googleアカウントでログイン',
          body: '同期ボタン（↻）をタップすると、Googleアカウントでのサインインを促されます。ログイン後にデータが安全にクラウドへ保存されます。',
        ),
        _ManualItem(
          icon: Icons.sync,
          iconColor: Colors.teal,
          title: '手動同期',
          body: 'ログイン後はいつでも同期ボタンを押すことで、端末とクラウドのデータを最新状態に同期できます。機種変更時のデータ引き継ぎにも使えます。',
        ),
        _SectionHeader(title: 'AI予測・分析'),
        _ManualItem(
          icon: Icons.auto_graph,
          iconColor: Colors.purple,
          title: '次回予測チップ',
          body: '記録が2件以上あるタスクには、過去の間隔を学習した「次は〇〇時頃」という予測が表示されます。',
        ),
        _ManualItem(
          icon: Icons.bar_chart,
          iconColor: Colors.indigo,
          title: '全タスクのグラフ表示',
          body: '無料版では基本5タスクのみ表示されるグラフが、プレミアムではカスタムタスクを含む全タスクで表示されます。',
        ),
        _SectionHeader(title: 'その他'),
        _ManualItem(
          icon: Icons.child_care,
          iconColor: Colors.pink,
          title: '成長記録の管理',
          body: '上部の「子どもアイコン」から身長・体重・頭囲・予防接種などを記録できます。時系列で変化を確認できます。',
        ),
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
