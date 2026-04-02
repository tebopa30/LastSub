import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/growth_record_entity.dart';
import '../application/growth_notifier.dart';
import '../../premium/application/premium_status_notifier.dart';
import 'widgets/growth_chart.dart';
import 'widgets/growth_input_modal.dart';
import '../../../core/services/csv_export_service.dart' show PdfExportService;

class GrowthPage extends ConsumerWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(growthRecordsStreamProvider);
    final premiumStatusAsync = ref.watch(premiumStatusProvider);
    final isPremium = premiumStatusAsync.value?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('成長の記録'),
        actions: [
          if (isPremium)
            IconButton(
              icon: const Icon(Icons.download_outlined),
              tooltip: 'PDFで出力',
              onPressed: () async {
                final records = recordsAsync.value ?? [];
                try {
                  await PdfExportService.exportGrowth(records);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PDF出力に失敗しました: $e')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: recordsAsync.when(
        data: (records) {
          // ソート：新しい日付順（リポジトリの出力を前提とするが念のため）
          final sorted = List<GrowthRecordEntity>.from(records)
            ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

          return Column(
            children: [
              // ── 成長曲線グラフ表示 ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: GrowthChart(records: sorted, isPremium: isPremium),
              ),

              // ── プレミアム導線 ──
              if (!isPremium)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      _showPremiumDialog(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 18,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'グラフの拡大や詳細履歴はプレミアム限定',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── 履歴リスト ──
              Expanded(
                child: sorted.isEmpty
                    ? const Center(child: Text('まだ記録がありません'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80, top: 16),
                        itemCount: sorted.length,
                        itemBuilder: (context, index) {
                          final record = sorted[index];
                          final dateStr = DateFormat(
                            'yyyy/MM/dd HH:mm',
                          ).format(record.recordedAt);

                          // 成長項目文字列の組み立て
                          final parts = <String>[];
                          if (record.height != null)
                            parts.add('${record.height}cm');
                          if (record.weight != null)
                            parts.add('${record.weight}kg');
                          if (record.headCircumference != null)
                            parts.add('頭囲${record.headCircumference}cm');

                          final hasVaccine =
                              record.vaccinationName != null &&
                              record.vaccinationName!.isNotEmpty;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateStr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (hasVaccine)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer,
                                                borderRadius: BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                              child: Text(
                                                '予防接種',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onTertiaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined),
                                            iconSize: 20,
                                            tooltip: '編集',
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Colors.transparent,
                                                builder: (_) => GrowthInputModal(initialData: record),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            iconSize: 20,
                                            tooltip: '削除',
                                            color: Theme.of(context).colorScheme.error,
                                            onPressed: () async {
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('記録を削除しますか？'),
                                                  content: Text('$dateStrの記録を削除します。\nこの操作は元に戻せません。'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx, false),
                                                      child: const Text('キャンセル'),
                                                    ),
                                                    FilledButton(
                                                      style: FilledButton.styleFrom(
                                                        backgroundColor: Theme.of(context).colorScheme.error,
                                                        foregroundColor: Theme.of(context).colorScheme.onError,
                                                      ),
                                                      onPressed: () => Navigator.pop(ctx, true),
                                                      child: const Text('削除'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirmed == true && context.mounted) {
                                                await ref.read(growthProvider.notifier).deleteRecord(record.id);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (parts.isNotEmpty)
                                    Text(
                                      parts.join(' / '),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  if (hasVaccine)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        '接種: ${record.vaccinationName!}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (record.memo != null &&
                                      record.memo!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        record.memo!,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('エラーが発生しました: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const GrowthInputModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('プレミアム機能'),
        content: const Text(
          '過去すべての成長データの可視化や、月齢に応じた細かい成長の軌跡グラフの利用はプレミアムプラン限定となります。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('閉じる'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('アップグレード'),
          ),
        ],
      ),
    );
  }
}
