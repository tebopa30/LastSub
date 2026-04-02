import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/growth_notifier.dart';
import '../../domain/growth_record_entity.dart';

class GrowthInputModal extends ConsumerStatefulWidget {
  const GrowthInputModal({super.key, this.initialData});

  /// 編集時に渡す既存レコード。null の場合は新規追加。
  final GrowthRecordEntity? initialData;

  @override
  ConsumerState<GrowthInputModal> createState() => _GrowthInputModalState();
}

class _GrowthInputModalState extends ConsumerState<GrowthInputModal> {
  late DateTime _selectedDate;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _headController;
  late final TextEditingController _vaccineController;
  late final TextEditingController _memoController;

  bool get _isEditing => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _selectedDate = d?.recordedAt ?? DateTime.now();
    _heightController = TextEditingController(text: d?.height?.toString() ?? '');
    _weightController = TextEditingController(text: d?.weight?.toString() ?? '');
    _headController = TextEditingController(text: d?.headCircumference?.toString() ?? '');
    _vaccineController = TextEditingController(text: d?.vaccinationName ?? '');
    _memoController = TextEditingController(text: d?.memo ?? '');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _headController.dispose();
    _vaccineController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final head = double.tryParse(_headController.text);
    final vaccine = _vaccineController.text.trim();
    final memo = _memoController.text.trim();

    if (height == null && weight == null && head == null && vaccine.isEmpty && memo.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('入力データがありません')),
      );
      return;
    }

    try {
      if (_isEditing) {
        final updated = widget.initialData!.copyWith(
          recordedAt: _selectedDate,
          height: height,
          weight: weight,
          headCircumference: head,
          vaccinationName: vaccine.isNotEmpty ? vaccine : null,
          memo: memo.isNotEmpty ? memo : null,
        );
        await ref.read(growthProvider.notifier).updateRecord(updated);
      } else {
        await ref.read(growthProvider.notifier).addRecord(
          recordedAt: _selectedDate,
          height: height,
          weight: weight,
          headCircumference: head,
          vaccinationName: vaccine.isNotEmpty ? vaccine : null,
          memo: memo.isNotEmpty ? memo : null,
        );
      }
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? '成長記録を更新しました！' : '成長記録を保存しました！')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存エラー: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? '成長記録を編集' : '成長の記録・予防接種',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_today),
              label: Text('${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '身長 (cm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '体重 (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _headController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '頭囲 (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vaccineController,
              decoration: const InputDecoration(
                labelText: '予防接種 (種類など)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'メモ (副反応の様子など)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? '更新する' : '保存する',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
