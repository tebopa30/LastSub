import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_status_entity.freezed.dart';

@freezed
abstract class PremiumStatusEntity with _$PremiumStatusEntity {
  const factory PremiumStatusEntity({
    @Default(false) bool isPremium,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PremiumStatusEntity;
}
