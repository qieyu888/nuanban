import 'package:flutter/material.dart';
import '../services/iap_service.dart';
import '../utils/coin_manager.dart';
import '../utils/iap_products.dart';
import '../widgets/coin_icon.dart';

class WalletRechargeScreen extends StatefulWidget {
  const WalletRechargeScreen({super.key});

  @override
  State<WalletRechargeScreen> createState() => _WalletRechargeScreenState();
}

class _WalletRechargeScreenState extends State<WalletRechargeScreen> {
  int _currentCoins = 0;
  int _selectedIndex = -1;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _bindIapCallbacks();
  }

  @override
  void dispose() {
    final iap = IapService.instance;
    iap.onPurchaseSuccess = null;
    iap.onPurchaseError = null;
    iap.isPurchasing.removeListener(_onPurchasingChanged);
    super.dispose();
  }

  void _bindIapCallbacks() {
    final iap = IapService.instance;
    iap.onPurchaseSuccess = (coins) {
      if (!mounted) return;
      _loadCoins();
      setState(() {
        _selectedIndex = -1;
        _isPurchasing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('充值成功！+$coins 金币'),
            ],
          ),
          backgroundColor: const Color(0xFF52C41A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    };
    iap.onPurchaseError = (message) {
      if (!mounted) return;
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFF5222D),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    };
    iap.isPurchasing.addListener(_onPurchasingChanged);
  }

  void _onPurchasingChanged() {
    if (!mounted) return;
    setState(() {
      _isPurchasing = IapService.instance.isPurchasing.value;
    });
  }

  void _loadCoins() {
    setState(() {
      _currentCoins = CoinManager.getCoins();
    });
  }

  IapProduct? get _selectedProduct =>
      _selectedIndex >= 0 ? IapProducts.all[_selectedIndex] : null;

  Future<void> _handleRecharge() async {
    final product = _selectedProduct;
    if (product == null || _isPurchasing) return;
    await IapService.instance.purchase(product.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '我的钱包',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 16),
                  _buildRechargeOptions(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9D31FF),
            Color(0xFFF260FF),
            Color(0xFFFF609F),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D31FF).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '当前金币余额',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CoinIcon(size: 40, showShadow: false),
              const SizedBox(width: 12),
              Text(
                _currentCoins.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择充值金额',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '通过 Apple 内购安全支付',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(IapProducts.all.length, (index) {
              if (index > 0) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: _buildRechargeOption(index),
                  ),
                );
              }
              return Expanded(child: _buildRechargeOption(index));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeOption(int index) {
    final product = IapProducts.all[index];
    final isSelected = _selectedIndex == index;
    final isRecommended = index == 1;

    return GestureDetector(
      onTap: _isPurchasing
          ? null
          : () {
              setState(() => _selectedIndex = index);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF9D31FF),
                    Color(0xFFF260FF),
                    Color(0xFFFF609F),
                  ],
                )
              : null,
          color: isSelected ? null : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(16),
          border: isRecommended && !isSelected
              ? Border.all(color: const Color(0xFFFF609F).withValues(alpha: 0.5))
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9D31FF).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 18,
              child: isRecommended
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.2)]
                              : const [Color(0xFFFF609F), Color(0xFFF260FF)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '推荐',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              '¥${product.price}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CoinIcon(size: 16, showShadow: false),
                const SizedBox(width: 4),
                Text(
                  '${product.coins}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '金币',
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final selected = _selectedProduct;
    final canPurchase = selected != null && !_isPurchasing;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '充值金额',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '¥${selected.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '获得金币',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '${selected.coins} 金币',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9D31FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            GestureDetector(
              onTap: canPurchase ? _handleRecharge : null,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: canPurchase
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9D31FF),
                            Color(0xFFF260FF),
                            Color(0xFFFF609F),
                          ],
                        )
                      : null,
                  color: canPurchase ? null : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: canPurchase
                      ? [
                          BoxShadow(
                            color: const Color(0xFF9D31FF).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: _isPurchasing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          selected != null ? '立即充值' : '请选择充值金额',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: canPurchase ? Colors.white : const Color(0xFF999999),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
