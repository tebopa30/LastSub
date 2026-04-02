import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../domain/growth_record_entity.dart';
import '../../auth/application/auth_provider.dart';
import '../../../core/providers/repository_providers.dart';

part 'growth_notifier.g.dart';

@riverpod
Stream<List<GrowthRecordEntity>> growthRecordsStream(Ref ref) async* {
  final repo = await ref.watch(localGrowthRepositoryProvider.future);
  final userId = ref.watch(currentUidProvider);

  yield* repo.watchRecords(userId);
}

@riverpod
class GrowthNotifier extends _$GrowthNotifier {
  @override
  void build() {}

  /// 成長記録を追加する
  Future<void> addRecord({
    required DateTime recordedAt,
    double? height,
    double? weight,
    double? headCircumference,
    String? vaccinationName,
    String? memo,
  }) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);
    final userId = ref.read(currentUidProvider);

    debugPrint('GrowthNotifier.addRecord: userId=$userId recordedAt=$recordedAt');

    if (userId == kLocalUserId) {
      debugPrint('GrowthNotifier.addRecord: WARNING - saving under local fallback userId');
    }

    final record = GrowthRecordEntity(
      id: const Uuid().v4(),
      userId: userId,
      recordedAt: recordedAt,
      height: height,
      weight: weight,
      headCircumference: headCircumference,
      vaccinationName: vaccinationName,
      memo: memo,
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await repo.saveRecord(record);
    debugPrint('GrowthNotifier.addRecord: save completed for id=${record.id}');
  }

  /// 既存の成長記録を更新する
  Future<void> updateRecord(GrowthRecordEntity updated) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);
    debugPrint('GrowthNotifier.updateRecord: id=${updated.id}');
    await repo.saveRecord(updated.copyWith(updatedAt: DateTime.now()));
    debugPrint('GrowthNotifier.updateRecord: completed for id=${updated.id}');
  }

  /// 記録を削除（論理削除）する
  Future<void> deleteRecord(String id) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);
    final userId = ref.read(currentUidProvider);

    await repo.deleteRecord(id, userId);
  }
}
