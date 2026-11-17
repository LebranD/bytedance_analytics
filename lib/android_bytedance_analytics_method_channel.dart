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
  Future<void> init({bool enableLog = false}) async {
    await methodChannel.invokeMethod<void>('init', {'enableLog': enableLog});
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
