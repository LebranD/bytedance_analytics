import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bytedance_analytics_method_channel.dart';

abstract class BytedanceAnalyticsPlatform extends PlatformInterface {
  /// Constructs a BytedanceAnalyticsPlatform.
  BytedanceAnalyticsPlatform() : super(token: _token);

  static final Object _token = Object();

  static BytedanceAnalyticsPlatform _instance = MethodChannelBytedanceAnalytics();

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

  // final boolean enableImei = (boolean) arguments.get("enableImei");
  // final boolean enableAutoTrack = (boolean) arguments.get("enableAutoTrack");
  // final boolean enableLog = (boolean) arguments.get("enableLog");
  // final boolean encryptAndCompress = (boolean) arguments.get("encryptAndCompress");
  // final boolean enablePlay = (boolean) arguments.get("enablePlay");
  Future<void> init({
    required String appId,
    bool enableImei = false,
    bool enableAutoTrack = false,
    bool enableLog = false,
    bool encryptAndCompress = true,
    bool enablePlay = true,
    bool enableAutoStart = false,
  }) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> start() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
