import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bytedance_analytics/bytedance_analytics_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBytedanceAnalytics platform = MethodChannelBytedanceAnalytics();
  const MethodChannel channel = MethodChannel('bytedance_analytics');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
