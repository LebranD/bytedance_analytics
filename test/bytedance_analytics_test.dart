import 'package:flutter_test/flutter_test.dart';
import 'package:bytedance_analytics/bytedance_analytics.dart';
import 'package:bytedance_analytics/bytedance_analytics_platform_interface.dart';
import 'package:bytedance_analytics/bytedance_analytics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBytedanceAnalyticsPlatform with MockPlatformInterfaceMixin implements BytedanceAnalyticsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> init({
    required String appId,
    bool enableImei = false,
    bool enableAutoTrack = false,
    bool enableLog = false,
    bool encryptAndCompress = true,
    bool enablePlay = true,
    bool autoStart = false,
  }) async {}

  @override
  Future<void> start() async {}
}

void main() {
  final BytedanceAnalyticsPlatform initialPlatform = BytedanceAnalyticsPlatform.instance;

  test('$MethodChannelBytedanceAnalytics is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBytedanceAnalytics>());
  });

  test('getPlatformVersion', () async {
    BytedanceAnalytics bytedanceAnalyticsPlugin = BytedanceAnalytics();
    MockBytedanceAnalyticsPlatform fakePlatform = MockBytedanceAnalyticsPlatform();
    BytedanceAnalyticsPlatform.instance = fakePlatform;

    expect(await bytedanceAnalyticsPlugin.getPlatformVersion(), '42');
  });
}
