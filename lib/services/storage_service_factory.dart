import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import 'web_storage_service.dart';

/// 存储服务工厂类，根据平台返回合适的存储服务实现
class StorageServiceFactory {
  /// 获取适合当前平台的存储服务实例
  static dynamic getStorageService() {
    if (kIsWeb) {
      // Web平台使用IndexedDB存储
      return WebStorageService();
    } else {
      // 非Web平台使用SharedPreferences存储
      return StorageService();
    }
  }
}