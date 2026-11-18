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
### Android 初始化

Android 使用 AppConvert 2.0.6，不需要 App ID。用户同意隐私政策后，在前台
Activity 可用时调用 `init()`；SDK 自动发送一次启动事件。`start()` 在 Android
不再发送启动事件。初始化和发送结果通过 Android logcat 的 `BytedanceConvert`
标签记录；调用返回只表示初始化方法已调用，不代表网络发送或平台检测成功。
2.x 不再使用旧版 RangersAppLog；`enableImei`、`enableAutoTrack`、
`encryptAndCompress`、`enablePlay` 和 `enableAutoStart` 已从插件接口移除。

### HarmonyOS 初始化

鸿蒙侧使用 AppConvert 0.0.4。在宿主声明 `ohos.permission.APP_TRACKING_CONSENT`、配置巨量 OHPM 仓库，且用户同意隐私政策后，调用 `BytedanceAnalyticsPlatform.instance.initOhos()`，再调用 `start()` 发送启动事件。插件请求跟踪授权；拒绝时关闭 SDK 的 OAID 采集，但仍发送启动事件。同一进程内重复调用不会重复发送。`getOaid()` 在未授权时返回 null。调用返回不代表网络发送或平台检测成功。
