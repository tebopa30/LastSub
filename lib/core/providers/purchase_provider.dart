import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'premium_provider.dart';

const kPremiumProductId = 'lastsub_premium_monthly';

enum IAPStatus { loading, ready, unavailable, purchasing, error }

class PurchaseUiState {
  final IAPStatus status;
  final ProductDetails? productDetails;
  final String? errorMessage;

  const PurchaseUiState({
    required this.status,
    this.productDetails,
    this.errorMessage,
  });

  PurchaseUiState copyWith({
    IAPStatus? status,
    ProductDetails? productDetails,
    String? errorMessage,
  }) {
    return PurchaseUiState(
      status: status ?? this.status,
      productDetails: productDetails ?? this.productDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final purchaseProvider =
    AsyncNotifierProvider<PurchaseNotifier, PurchaseUiState>(
        PurchaseNotifier.new);

class PurchaseNotifier extends AsyncNotifier<PurchaseUiState> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  Future<PurchaseUiState> build() async {
    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) {
      return const PurchaseUiState(status: IAPStatus.unavailable);
    }

    // Listen to purchase updates
    _subscription = iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object e) {
        state = AsyncData(PurchaseUiState(
          status: IAPStatus.error,
          errorMessage: e.toString(),
        ));
      },
    );
    ref.onDispose(() => _subscription?.cancel());

    // Restore any previous purchases on startup
    await iap.restorePurchases();

    // Query product details
    final response =
        await iap.queryProductDetails({kPremiumProductId});
    if (response.error != null || response.productDetails.isEmpty) {
      return const PurchaseUiState(status: IAPStatus.unavailable);
    }

    return PurchaseUiState(
      status: IAPStatus.ready,
      productDetails: response.productDetails.first,
    );
  }

  Future<void> buyPremium() async {
    if (state is! AsyncData<PurchaseUiState>) return;
    final current = (state as AsyncData<PurchaseUiState>).value;
    if (current.productDetails == null) return;

    state = AsyncData(current.copyWith(status: IAPStatus.purchasing));

    final param = PurchaseParam(productDetails: current.productDetails!);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != kPremiumProductId) continue;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await ref.read(isPremiumProvider.notifier).setPremium(true);
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
        final current = state is AsyncData<PurchaseUiState>
            ? (state as AsyncData<PurchaseUiState>).value
            : null;
        if (current != null) {
          state = AsyncData(current.copyWith(status: IAPStatus.ready));
        }
      } else if (purchase.status == PurchaseStatus.error) {
        final current = state is AsyncData<PurchaseUiState>
            ? (state as AsyncData<PurchaseUiState>).value
            : null;
        state = AsyncData(PurchaseUiState(
          status: IAPStatus.error,
          productDetails: current?.productDetails,
          errorMessage: purchase.error?.message,
        ));
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        final current = state is AsyncData<PurchaseUiState>
            ? (state as AsyncData<PurchaseUiState>).value
            : null;
        if (current != null) {
          state = AsyncData(current.copyWith(status: IAPStatus.ready));
        }
      } else if (purchase.status == PurchaseStatus.pending) {
        // Keep purchasing state
      }
    }
  }
}
