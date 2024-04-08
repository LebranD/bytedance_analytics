import Flutter
import UIKit
import BDASignalSDK

public class BytedanceAnalyticsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bytedance_analytics", binaryMessenger: registrar.messenger())
        let instance = BytedanceAnalyticsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    private func initBDA(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        BDASignalManager.register(withOptionalData: [kBDADSignalSDKUserUniqueId: "toutiao"])
        result(nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "init":
            initBDA(call, result: result)
        case "start":
            BDASignalManager.startSendingEvents()
            result(nil)
        case "getClickId":
            result(BDASignalManager.getClickId())
        case "getIdfv":
            result(BDASignalUtility.idfv())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        BDASignalManager.enableDelayUpload();
        BDASignalManager.didFinishLaunching(options: launchOptions, connect: nil);
        return true
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        BDASignalManager.anylyseDeeplinkClickid(withOpenUrl: url.absoluteString);
        return true
    }
}
