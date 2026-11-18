import 'package:bytedance_analytics/ohos_bytedance_analytics_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('bytedance_analytics');
  final calls = <MethodCall>[];
  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'getOaid') return null;
      return null;
    });
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  test('initializes after consent and starts through the Harmony bridge',
      () async {
    final plugin = OhosMethodChannelBytedanceAnalytics();
    await plugin.initOhos(enableLog: true);
    await plugin.start();
    expect(calls.map((call) => call.method), ['init', 'start']);
    expect(calls.first.arguments, {'enableLog': true});
    expect(await plugin.getOaid(), isNull);
  });
}
