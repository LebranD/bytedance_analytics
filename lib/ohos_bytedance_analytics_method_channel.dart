import 'package:flutter/services.dart';

import 'bytedance_analytics_platform_interface.dart';

class OhosMethodChannelBytedanceAnalytics extends BytedanceAnalyticsPlatform {
  final MethodChannel methodChannel =
      const MethodChannel('bytedance_analytics');

  @override
  Future<void> initOhos({bool enableLog = false}) async {
    await methodChannel.invokeMethod<void>('init', {'enableLog': enableLog});
  }

  @override
  Future<void> start() async {
    await methodChannel.invokeMethod<void>('start');
  }

  @override
  Future<String?> getOaid() => methodChannel.invokeMethod<String>('getOaid');

  @override
  Future<String?> getPlatformVersion() =>
      methodChannel.invokeMethod<String>('getPlatformVersion');
}
