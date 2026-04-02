import 'package:cloud_firestore/cloud_firestore.dart';

/// 同期処理における例外を扱うクラス
class SyncException implements Exception {
  final String errorCode;
  final dynamic originalError;

  SyncException(this.errorCode, {this.originalError});

  /// ユーザーに表示するための日本語メッセージを返す
  String get userMessage {
    switch (errorCode) {
      case 'network':
        return 'インターネット接続を確認してください';
      case 'permission-denied':
        return '無料版ではクラウド同期は利用できません';
      case 'unauthenticated':
        return 'Firebase認証が完了していません。アプリを再起動してから再試行してください（プレミアム購入とは別の設定です）';
      case 'auth_pending':
        return '認証処理中です。しばらく待ってから再試行してください';
      case 'server':
        return 'サーバーが混み合っています';
      case 'timeout':
        return '同期処理がタイムアウトしました。しばらく時間をおいて再試行してください';
      default:
        return '同期中にエラーが発生しました';
    }
  }

  @override
  String toString() => 'SyncException: $errorCode ($originalError)';

  /// FirebaseException 等から SyncException を生成するファクトリメソッド
  factory SyncException.fromError(dynamic e) {
    if (e is SyncException) return e;

    if (e is FirebaseException) {
      switch (e.code) {
        case 'permission-denied':
          return SyncException('permission-denied', originalError: e);
        case 'unavailable':
        case 'deadline-exceeded':
          return SyncException('network', originalError: e);
        default:
          return SyncException('server', originalError: e);
      }
    }

    // ネットワークエラーの判定（SocketException や TimeoutException など）
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('socketexception') || 
        errorString.contains('network') || 
        errorString.contains('connection')) {
      return SyncException('network', originalError: e);
    }

    if (errorString.contains('timeout')) {
      return SyncException('timeout', originalError: e);
    }

    return SyncException('unknown', originalError: e);
  }
}
