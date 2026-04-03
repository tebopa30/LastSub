import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../domain/growth_record_entity.dart';
import '../../../core/providers/repository_providers.dart';

part 'growth_notifier.g.dart';

const _kLocalUserId = 'local_user';

@riverpod
Stream<List<GrowthRecordEntity>> growthRecordsStream(Ref ref) async* {
  final repo = await ref.watch(localGrowthRepositoryProvider.future);
  yield* repo.watchRecords(_kLocalUserId);
}

@riverpod
class GrowthNotifier extends _$GrowthNotifier {
  @override
  void build() {}

  Future<void> addRecord({
    required DateTime recordedAt,
    double? height,
    double? weight,
    double? headCircumference,
    String? vaccinationName,
    String? memo,
  }) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);

    final record = GrowthRecordEntity(
      id: const Uuid().v4(),
      userId: _kLocalUserId,
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
    debugPrint('GrowthNotifier.addRecord: saved id=${record.id}');
  }

  Future<void> updateRecord(GrowthRecordEntity updated) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);
    await repo.saveRecord(updated.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteRecord(String id) async {
    final repo = await ref.read(localGrowthRepositoryProvider.future);
    await repo.deleteRecord(id, _kLocalUserId);
  }
}
