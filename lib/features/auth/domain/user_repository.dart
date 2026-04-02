import 'user_entity.dart';

abstract class UserRepository {
  /// 現在のユーザー情報を取得（未作成ならnull）
  Future<UserEntity?> fetchCurrentUser(String id);

  /// ユーザー情報の新規作成、または更新（アップサート）
  Future<void> saveUser(UserEntity user);
  
  /// (将来用) ログイン中のユーザー情報を監視するStream
  Stream<UserEntity?> watchCurrentUser(String id);
}
