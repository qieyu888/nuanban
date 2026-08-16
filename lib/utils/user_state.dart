import 'dart:io';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  static final UserState _instance = UserState._internal();
  factory UserState() => _instance;
  UserState._internal();

  // 头像相关
  String _avatarPath = 'assets/images/tx.jpg';
  bool _isAssetImage = true;
  bool _isFileImage = false;

  // 用户信息
  String _nickname = '旅行探索者';
  String _signature = '用镜头记录世界，用文字分享故事 ✨';
  String _gender = '保密';
  List<String> _interests = ['旅行', '摄影'];

  // Getters
  String get avatarPath => _avatarPath;
  bool get isAssetImage => _isAssetImage;
  bool get isFileImage => _isFileImage;
  String get nickname => _nickname;
  String get signature => _signature;
  String get gender => _gender;
  List<String> get interests => _interests;

  // 更新头像
  void updateAvatar(String path, {bool isAsset = false, bool isFile = false}) {
    _avatarPath = path;
    _isAssetImage = isAsset;
    _isFileImage = isFile;
    notifyListeners();
  }

  // 更新用户信息
  void updateProfile({
    String? nickname,
    String? signature,
    String? gender,
    List<String>? interests,
  }) {
    if (nickname != null) _nickname = nickname;
    if (signature != null) _signature = signature;
    if (gender != null) _gender = gender;
    if (interests != null) _interests = interests;
    notifyListeners();
  }

  // 重置为默认
  void resetToDefault() {
    _avatarPath = 'assets/images/tx.jpg';
    _isAssetImage = true;
    _isFileImage = false;
    _nickname = '旅行探索者';
    _signature = '用镜头记录世界，用文字分享故事 ✨';
    _gender = '保密';
    _interests = ['旅行', '摄影'];
    notifyListeners();
  }

  ImageProvider getAvatarImage() {
    if (_isFileImage) {
      return FileImage(File(_avatarPath));
    } else if (_isAssetImage) {
      return AssetImage(_avatarPath);
    } else {
      return NetworkImage(_avatarPath);
    }
  }
}
