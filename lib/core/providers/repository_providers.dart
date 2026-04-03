import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../../features/task/data/local_task_repository.dart';
import '../../features/task/data/local_task_record_repository.dart';
import '../../features/growth/data/local_growth_repository.dart';

final localGrowthRepositoryProvider =
    FutureProvider<LocalGrowthRepository>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return LocalGrowthRepository(db);
});

/// 🔥 非同期初期化対応
/// LocalTaskRepository を保持する FutureProvider
final taskRepositoryProvider =
    FutureProvider<LocalTaskRepository>((ref) async {
  // keepAlive でプロバイダ破棄を防ぐ
  ref.keepAlive();

  // databaseProvider.future で DB の解決を正しく await する
  // .requireValue は DB がまだロード中のタイミングで呼ぶと StateError をスローするため使わない
  final db = await ref.watch(databaseProvider.future);

  final repo = await LocalTaskRepository.create(db);

  // dispose 時に StreamController を閉じる
  ref.onDispose(() {
    repo.dispose();
  });

  return repo;
});

/// LocalTaskRecordRepository は同期で作れるが
/// TaskRepository が非同期なので watch する
final taskRecordRepositoryProvider =
    Provider<LocalTaskRecordRepository>((ref) {
  final dbAsync = ref.watch(databaseProvider);
  final taskRepoAsync = ref.watch(taskRepositoryProvider);

  if (!dbAsync.hasValue || !taskRepoAsync.hasValue) {
    throw Exception('repositories not initialized yet');
  }

  final repo = LocalTaskRecordRepository(dbAsync.requireValue, taskRepoAsync.requireValue);
  ref.onDispose(repo.dispose);
  return repo;
});

