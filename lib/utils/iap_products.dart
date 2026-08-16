/// App Store 内购商品配置（productId 与 App Store Connect 一致）
class IapProduct {
  final String productId;
  final int price;
  final int coins;

  const IapProduct({
    required this.productId,
    required this.price,
    required this.coins,
  });
}

class IapProducts {
  static const List<IapProduct> all = [
    IapProduct(productId: 'nuanban_8', price: 8, coins: 96),
    IapProduct(productId: 'nuanban_28', price: 28, coins: 326),
    IapProduct(productId: 'nuanban_58', price: 58, coins: 666),
  ];

  static const Set<String> productIds = {
    'nuanban_8',
    'nuanban_28',
    'nuanban_58',
  };

  static IapProduct? findByProductId(String productId) {
    for (final product in all) {
      if (product.productId == productId) return product;
    }
    return null;
  }

  static int coinsForProductId(String productId) {
    return findByProductId(productId)?.coins ?? 0;
  }
}
