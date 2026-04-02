import 'package:flutter/material.dart';
import '../task_design_helper.dart';

class AddTaskModal extends StatefulWidget {
  final void Function(String title, String iconName, String colorCode) onSave;

  const AddTaskModal({super.key, required this.onSave});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleController = TextEditingController();
  String _selectedIcon = 'child_care';
  String _selectedColor = 'yellow';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タスク名を入力してください')),
      );
      return;
    }
    // Navigator.pop はコールバック側（task_list_page.dart）で行う
    widget.onSave(title, _selectedIcon, _selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    // プレビュー用のデザイン情報
    final previewDesign = getTaskDesignInfo(
      _titleController.text.trim(),
      iconName: _selectedIcon,
      colorCode: _selectedColor,
    );

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '新しいタスクを追加',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // プレビュー
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: previewDesign.backgroundColor,
                    child: Icon(
                      previewDesign.iconData,
                      color: previewDesign.iconColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'プレビュー',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // タイトル入力
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'タスク名',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // アイコン選択
            Text('アイコン', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableIcons.keys.map((iconKey) {
                final isSelected = _selectedIcon == iconKey;
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = iconKey),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Icon(availableIcons[iconKey],
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // カラー選択
            Text('テーマカラー', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableColors.keys.map((colorKey) {
                final isSelected = _selectedColor == colorKey;
                final colors = availableColors[colorKey]!;
                return InkWell(
                  onTap: () => setState(() => _selectedColor = colorKey),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors[0],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? colors[1] : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: colors[1], size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // 追加ボタン
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('追加する', style: TextStyle(fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
