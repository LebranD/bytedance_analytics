# bytedance_analytics

字节归因方案

## Getting Started

[安卓-巨量引擎转化归因融合优化方案接入流程](https://bytedance.larkoffice.com/docx/XV0HdbdAGoPByRxAR10cGAGrnKf)
[IOS-巨量引擎转化归因融合优化方案接入流程](https://bytedance.larkoffice.com/docx/AwasdI0KroSD6GxfDSrcd13Bn6b)

### iOS Scene 生命周期和隐私同意

使用 Scene 生命周期的 Flutter 应用需将 `Info.plist` 中
`UISceneDelegateClassName` 设置为 `BytedanceSceneDelegate`。该类继承
`FlutterSceneDelegate` 并继续转发 Flutter 的生命周期和 URL 路由。插件仅缓存
启动参数和巨量直达链接，宿主应在用户同意隐私政策后调用 `initIOS` 和 `start`；
`start` 才初始化 SDK 并发送启动事件。同一进程内重复调用不会重复发送启动事件。
当前锁定的 BDASignalSDK 1.0.6 默认开启 IDFA 采集，插件显式关闭该开关。
Android 旧版 SDK 使用应用管理中心提供的非空 App ID 和渠道名，并在同意后调用。
