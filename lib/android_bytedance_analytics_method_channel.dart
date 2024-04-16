import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bytedance_analytics_platform_interface.dart';

/// An implementation of [BytedanceAnalyticsPlatform] that uses method channels.
class AndroidMethodChannelBytedanceAnalytics extends BytedanceAnalyticsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bytedance_analytics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> init({
    required String appId,
    bool enableImei = false,
    bool enableAutoTrack = false,
    bool enableLog = false,
    bool encryptAndCompress = true,
    bool enablePlay = true,
    bool enableAutoStart = false,
  }) async {
    return await methodChannel.invokeMethod<void>('init', {
      'appId': appId,
      'enableImei': enableImei,
      'enableAutoTrack': enableAutoTrack,
      'enableLog': enableLog,
      'encryptAndCompress': encryptAndCompress,
      'enablePlay': enablePlay,
      'enableAutoStart': enableAutoStart,
    });
  }

  @override
  Future<void> start() async {
    return await methodChannel.invokeMethod<void>('start');
  }

  @override
  Future<String?> getClickId() async {
    return await methodChannel.invokeMethod<String>('getClickId');
  }

  @override
  Future<String?> getAndroidId() async {
    return await methodChannel.invokeMethod<String>('getAndroidId');
  }
}
