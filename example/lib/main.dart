import 'package:bytedance_analytics/bytedance_analytics_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                BytedanceAnalyticsPlatform.instance.init(appId: '584352', channel: 'toutiao', enableLog: true);
              },
              child: const Text(
                '初始化',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                BytedanceAnalyticsPlatform.instance.start();
              },
              child: const Text(
                '开始上报',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                final androidId = await BytedanceAnalyticsPlatform.instance.getAndroidId();
                if (kDebugMode) {
                  print('androidId ==== $androidId');
                }
              },
              child: const Text(
                '获取AndroidId',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                final iosDeviceInfo = await DeviceInfoPlugin().iosInfo;

                final idfv = await BytedanceAnalyticsPlatform.instance.getIdfv();

                if (kDebugMode) {
                  print('iosDeviceInfo.idfv ==== ${iosDeviceInfo.identifierForVendor}');
                  print('idfv ==== $idfv');
                }
              },
              child: const Text(
                '获取Idfv',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
