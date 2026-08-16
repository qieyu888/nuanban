import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../utils/coin_manager.dart';
import '../utils/iap_products.dart';

/// iOS 内购服务（标准 StoreKit 流程，勿改核心购买链路）
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _initialized = false;

  final ValueNotifier<bool> isPurchasing = ValueNotifier(false);

  void Function(int coins)? onPurchaseSuccess;
  void Function(String message)? onPurchaseError;

  Future<void> init() async {
    if (_initialized || !Platform.isIOS) return;
    _initialized = true;

    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        isPurchasing.value = false;
        onPurchaseError?.call('购买失败：$error');
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    isPurchasing.dispose();
  }

  Future<void> purchase(String productId) async {
    if (!Platform.isIOS) {
      onPurchaseError?.call('仅支持 iOS 内购');
      return;
    }

    if (isPurchasing.value) return;

    final product = IapProducts.findByProductId(productId);
    if (product == null) {
      onPurchaseError?.call('商品不存在');
      return;
    }

    isPurchasing.value = true;

    try {
      final response = await _iap.queryProductDetails({productId});
      if (response.error != null) {
        throw Exception(response.error!.message);
      }
      if (response.notFoundIDs.isNotEmpty) {
        throw Exception('未找到商品：${response.notFoundIDs.join(', ')}');
      }
      if (response.productDetails.isEmpty) {
        throw Exception('商品信息为空');
      }

      final purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      final started = await _iap.buyConsumable(purchaseParam: purchaseParam);
      if (!started) {
        isPurchasing.value = false;
        onPurchaseError?.call('无法发起购买');
      }
    } catch (e) {
      isPurchasing.value = false;
      onPurchaseError?.call(e.toString());
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          isPurchasing.value = false;
          onPurchaseError?.call(
            purchase.error?.message ?? '购买失败',
          );
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.canceled:
          isPurchasing.value = false;
          onPurchaseError?.call('已取消购买');
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliverProduct(purchase);
          break;
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    final coins = IapProducts.coinsForProductId(purchase.productID);
    if (coins > 0) {
      await CoinManager.addCoins(coins);
      onPurchaseSuccess?.call(coins);
    }

    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
    isPurchasing.value = false;
  }
}
