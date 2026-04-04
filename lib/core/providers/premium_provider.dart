import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

final isPremiumProvider = NotifierProvider<PremiumNotifier, bool>(PremiumNotifier.new);

class PremiumNotifier extends Notifier<bool> {
  static const _key = 'is_premium';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> setPremium(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
    state = value;
  }
}
