import 'dart:io';

import 'package:bytedance_analytics/darwin_bytedance_analytics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_bytedance_analytics_method_channel.dart';

abstract class BytedanceAnalyticsPlatform extends PlatformInterface {
  /// Constructs a BytedanceAnalyticsPlatform.
  BytedanceAnalyticsPlatform() : super(token: _token);

  static final Object _token = Object();

  static BytedanceAnalyticsPlatform _instance =
      Platform.isAndroid ? AndroidMethodChannelBytedanceAnalytics() : DarwinMethodChannelBytedanceAnalytics();

  /// The default instance of [BytedanceAnalyticsPlatform] to use.
  ///
  /// Defaults to [MethodChannelBytedanceAnalytics].
  static BytedanceAnalyticsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BytedanceAnalyticsPlatform] when
  /// they register themselves.
  static set instance(BytedanceAnalyticsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init({
    required String appId,
    bool enableImei = false,
    bool enableAutoTrack = false,
    bool enableLog = false,
    bool encryptAndCompress = true,
    bool enablePlay = true,
    bool enableAutoStart = false,
  }) async {
    //
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initIOS() async {
    throw UnimplementedError('initIOS() has not been implemented.');
  }

  Future<void> start() async {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future<String?> getClickId() async {
    throw UnimplementedError('getClickId() has not been implemented.');
  }

  Future<String?> getIdfv() async {
    throw UnimplementedError('getIdfv() has not been implemented.');
  }

  Future<String?> getAndroidId() async {
    throw UnimplementedError('getIdfv() has not been implemented.');
  }
}
