import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局关注状态，跨动态列表 / 详情 / 用户主页同步
class FollowState extends ChangeNotifier {
  static final FollowState _instance = FollowState._internal();
  factory FollowState() => _instance;
  FollowState._internal();

  static const _prefsKey = 'followed_users';

  /// 与动态列表初始数据一致
  static const Map<String, bool> _defaultFollows = {
    '旅行摄影师小王': false,
    '美食探索家': true,
    '园林爱好者': false,
    '节日记录者': true,
    '山水画师': false,
    '京城食客': true,
    '古镇寻梦': false,
    '海边漫步': true,
    '夜景猎人': false,
    '美食达人': false,
  };

  final Map<String, bool> _follows = {};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        _follows[key] = value == true;
      });
    } else {
      _follows.addAll(_defaultFollows);
      await _save();
    }
    _loaded = true;
  }

  bool isFollowing(String username) {
    if (_follows.containsKey(username)) {
      return _follows[username]!;
    }
    return _defaultFollows[username] ?? false;
  }

  Future<bool> toggle(String username) async {
    await ensureLoaded();
    final next = !isFollowing(username);
    _follows[username] = next;
    await _save();
    notifyListeners();
    return next;
  }

  Future<void> setFollowing(String username, bool value) async {
    await ensureLoaded();
    _follows[username] = value;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_follows));
  }

  /// 注销账号时清空关注数据
  Future<void> clear() async {
    _follows.clear();
    _follows.addAll(_defaultFollows);
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    notifyListeners();
  }
}
