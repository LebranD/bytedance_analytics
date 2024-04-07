import 'package:bytedance_analytics/bytedance_analytics_platform_interface.dart';
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
                BytedanceAnalyticsPlatform.instance.init(appId: '584352', enableLog: true);
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
          ],
        ),
      ),
    );
  }
}
