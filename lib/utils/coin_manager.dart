import 'package:shared_preferences/shared_preferences.dart';

class CoinManager {
  static const String _coinKey = 'user_coins';
  static const int _initialCoins = 1000;

  /// 每次 AI 对话消耗的金币数
  static const int aiMessageCost = 1;

  // 获取金币余额
  static int getCoins() {
    // 这里使用同步方式，实际应用中应该异步加载
    // 为了简化，我们使用静态变量
    return _coins;
  }

  static int _coins = _initialCoins;

  // 初始化金币（从本地存储加载）
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _coins = prefs.getInt(_coinKey) ?? _initialCoins;
  }

  // 添加金币
  static Future<void> addCoins(int amount) async {
    _coins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinKey, _coins);
  }

  // 扣除金币
  static Future<bool> deductCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_coinKey, _coins);
      return true;
    }
    return false;
  }

  // 设置金币
  static Future<void> setCoins(int amount) async {
    _coins = amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinKey, _coins);
  }

  /// 注销账号时清空本地金币数据
  static Future<void> clear() async {
    _coins = _initialCoins;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinKey);
  }
}
