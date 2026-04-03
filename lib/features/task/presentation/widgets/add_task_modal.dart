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
  String _selectedIcon = 'check_circle';
  String _selectedColor = 'blue';

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
    widget.onSave(title, _selectedIcon, _selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorMap = isDark ? availableColorsSleek : availableColorsNatural;

    final previewDesign = getTaskDesignInfo(
      _titleController.text.trim(),
      iconName: _selectedIcon,
      colorCode: _selectedColor,
      isDark: isDark,
    );

    final borderRadius = isDark ? 4.0 : 24.0;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(isDark ? 4 : 28)),
        border: isDark
            ? const Border(top: BorderSide(color: Color(0xFF2E2E2E), width: 1))
            : null,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── ハンドル / タイトル ──
            if (!isDark)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            Text(
              isDark ? 'NEW TASK' : '新しいタスクを追加',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: isDark ? FontWeight.w300 : FontWeight.bold,
                    letterSpacing: isDark ? 4 : 0,
                  ),
            ),
            const SizedBox(height: 24),

            // ── プレビュー ──
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: previewDesign.backgroundColor,
                      borderRadius: BorderRadius.circular(isDark ? 4 : 36),
                      border: isDark
                          ? Border.all(color: previewDesign.iconColor.withValues(alpha: 0.4), width: 1)
                          : null,
                    ),
                    child: Icon(previewDesign.iconData,
                        color: previewDesign.iconColor, size: 36),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _titleController.text.trim().isEmpty
                        ? (isDark ? '---' : 'プレビュー')
                        : _titleController.text.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: isDark ? 2 : 0,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── タイトル入力 ──
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: isDark ? 'TASK NAME' : 'タスク名',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isDark ? 3 : 16),
                ),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // ── アイコン選択 ──
            _SectionLabel(label: isDark ? 'ICON' : 'アイコン', isDark: isDark),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: availableIcons.length,
              itemBuilder: (context, index) {
                final iconKey = availableIcons.keys.elementAt(index);
                final isSelected = _selectedIcon == iconKey;
                final accentColor = isDark
                    ? const Color(0xFF00E5FF)
                    : Theme.of(context).colorScheme.primary;

                return InkWell(
                  onTap: () => setState(() => _selectedIcon = iconKey),
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF003A42)
                              : Theme.of(context).colorScheme.primaryContainer)
                          : (isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: isSelected
                            ? accentColor
                            : (isDark
                                ? const Color(0xFF2A2A2A)
                                : Theme.of(context).colorScheme.outlineVariant),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Icon(
                      availableIcons[iconKey],
                      size: 22,
                      color: isSelected
                          ? accentColor
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // ── カラー選択 ──
            _SectionLabel(label: isDark ? 'COLOR' : 'テーマカラー', isDark: isDark),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: colorMap.length,
              itemBuilder: (context, index) {
                final colorKey = colorMap.keys.elementAt(index);
                final isSelected = _selectedColor == colorKey;
                final colors = colorMap[colorKey]!;

                return InkWell(
                  onTap: () => setState(() => _selectedColor = colorKey),
                  borderRadius: BorderRadius.circular(isDark ? 4 : 24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: colors[0],
                      borderRadius: BorderRadius.circular(isDark ? 4 : 24),
                      border: Border.all(
                        color: isSelected ? colors[1] : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: colors[1], size: 18)
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // ── 追加ボタン ──
            FilledButton.icon(
              icon: Icon(isDark ? Icons.add : Icons.add, size: 18),
              label: Text(
                isDark ? 'ADD TASK' : '追加する',
                style: TextStyle(
                  fontWeight: isDark ? FontWeight.w500 : FontWeight.bold,
                  letterSpacing: isDark ? 2 : 0,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDark ? 3 : 100),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isDark ? const Color(0xFF00E5FF) : null,
                foregroundColor: isDark ? const Color(0xFF000000) : null,
              ),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: isDark ? 11 : 13,
        fontWeight: isDark ? FontWeight.w400 : FontWeight.w600,
        letterSpacing: isDark ? 2.5 : 0,
        color: isDark
            ? const Color(0xFF666666)
            : Theme.of(context).textTheme.titleSmall?.color,
      ),
    );
  }
}
