import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../application/auth_controller.dart';

/// 同期機能利用時などに表示する Google サインイン案内ダイアログ
class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({super.key});

  /// ダイアログを表示し、サインイン成功なら true を返す
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const SignInDialog(),
        ) ??
        false;
  }

  @override
  ConsumerState<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends ConsumerState<SignInDialog> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // ref.watch でプロバイダーを購読 → ダイアログが表示されている間は破棄されない
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final notifier = ref.read(authControllerProvider.notifier);

    // 完了・エラーを ref.listen で検知し、ナビゲーション等の副作用を安全に処理
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (!mounted) return;
      if (next.hasError) {
        final err = next.error.toString();
        if (err.contains('キャンセル')) {
          Navigator.of(context).pop(false);
        } else {
          setState(() => _errorMessage = 'サインインに失敗しました。再度お試しください。');
        }
      } else if (next.hasValue && previous?.isLoading == true) {
        // ローディング → 成功 の遷移でダイアログを閉じる
        Navigator.of(context).pop(true);
      }
    });

    return AlertDialog(
      title: const Text('アカウント登録が必要です'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'クラウド同期にはアカウント登録が必要です。登録後は機種変更時もデータを引き継げます。',
          ),
          const SizedBox(height: 16),
          // Apple Sign-In ボタン（公式デザインガイドライン準拠）
          SignInWithAppleButton(
            onPressed: isLoading
                ? () {}
                : () {
                    setState(() => _errorMessage = null);
                    notifier.signInWithApple();
                  },
          ),
          const SizedBox(height: 8),
          // Google Sign-In ボタン
          OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    setState(() => _errorMessage = null);
                    notifier.signInWithGoogle();
                  },
            icon: const Icon(Icons.login, size: 18),
            label: const Text('Googleで登録'),
          ),
          if (isLoading) ...[
            const SizedBox(height: 12),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
