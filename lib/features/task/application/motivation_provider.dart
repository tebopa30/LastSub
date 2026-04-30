import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/task_entity.dart';
import 'task_notifier.dart';

part 'motivation_provider.g.dart';

enum GlobalHealth { excellent, good, warning, critical }

class MotivationState {
  final int points;
  final int streakDays;

  MotivationState({
    required this.points,
    required this.streakDays,
  });

  MotivationState copyWith({
    int? points,
    int? streakDays,
  }) {
    return MotivationState(
      points: points ?? this.points,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

@Riverpod(keepAlive: true)
class MotivationNotifier extends _$MotivationNotifier {
  late SharedPreferences _prefs;

  @override
  MotivationState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    
    final points = _prefs.getInt('motivation_points') ?? 0;
    final streakDays = _prefs.getInt('motivation_streak') ?? 0;

    return MotivationState(points: points, streakDays: streakDays);
  }

  Future<void> addPoints(int amount) async {
    final newPoints = state.points + amount;
    await _prefs.setInt('motivation_points', newPoints);
    state = state.copyWith(points: newPoints);
  }
}

@riverpod
GlobalHealth globalHealth(Ref ref) {
  final tasks = ref.watch(taskProvider).value ?? [];
  if (tasks.isEmpty) return GlobalHealth.good;

  int yellowCount = 0;
  int redCount = 0;
  int criticalRedCount = 0;
  int activeTaskCount = 0;

  final now = DateTime.now();

  for (final task in tasks) {
    final last = task.lastRecordedAt;
    if (last == null) continue;
    
    activeTaskCount++;
    final elapsedSecs = now.difference(last).inSeconds;
    final threshold = task.recommendedIntervalDays;

    if (threshold != null && threshold > 0) {
      if (elapsedSecs < threshold) {
        // green
      } else if (elapsedSecs < threshold * 1.5) {
        yellowCount++;
      } else if (elapsedSecs < threshold * 3) {
        redCount++;
      } else {
        redCount++;
        criticalRedCount++;
      }
    } else {
      final hours = elapsedSecs / 3600;
      if (hours < 24) {
        // green
      } else if (hours < 72) {
        yellowCount++;
      } else if (hours < 168) {
        redCount++;
      } else {
        redCount++;
        criticalRedCount++;
      }
    }
  }

  if (activeTaskCount == 0) return GlobalHealth.good;
  
  if (redCount == 0 && yellowCount == 0) return GlobalHealth.excellent;
  if (criticalRedCount >= 2 || redCount >= (activeTaskCount / 2).ceil()) return GlobalHealth.critical;
  if (redCount > 0) return GlobalHealth.warning;
  return GlobalHealth.good;
}
