import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bytedance_analytics_platform_interface.dart';

/// An implementation of [BytedanceAnalyticsPlatform] that uses method channels.
class DarwinMethodChannelBytedanceAnalytics extends BytedanceAnalyticsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bytedance_analytics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initIOS() async {
    return await methodChannel.invokeMethod<void>('init');
  }

  @override
  Future<void> start() async {
    return await methodChannel.invokeMethod<void>('start');
  }

  @override
  Future<String?> getClickId() async {
    return await methodChannel.invokeMethod<String>('getClickId');
  }

  Future<String?> getIdfv() async {
    return await methodChannel.invokeMethod<String>('getIdfv');
  }
}
