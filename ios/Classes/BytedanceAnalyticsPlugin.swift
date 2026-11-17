import Flutter
import UIKit
import BDASignalSDK

// Keep lifecycle inputs in memory until Flutter confirms privacy consent.
private enum SignalLifecycle {
    static var connectionOptions: UIScene.ConnectionOptions?
    static var launchOptions: [AnyHashable: Any]?
    static var pendingURLs: [URL] = []
    static var started = false

    static func receive(_ url: URL) {
        guard url.scheme?.lowercased() == Bundle.main.bundleIdentifier?.lowercased(),
              url.host?.lowercased() == "oceanengine" else { return }
        if started {
            BDASignalManager.anylyseDeeplinkClickid(withOpenUrl: url.absoluteString)
        } else {
            pendingURLs.append(url)
        }
    }

    static func start() {
        guard !started else { return }
        // In the installed 1.0.6 source IDFA defaults to enabled.
        BDASignalManager.enableIdfa(false)
        BDASignalManager.didFinishLaunching(options: connectionOptions == nil ? launchOptions : nil,
                                           connect: connectionOptions)
        started = true
        pendingURLs.forEach { BDASignalManager.anylyseDeeplinkClickid(withOpenUrl: $0.absoluteString) }
        pendingURLs.removeAll()
        connectionOptions = nil
        launchOptions = nil
    }
}

@objc(BytedanceSceneDelegate)
public class BytedanceSceneDelegate: FlutterSceneDelegate {
    public override func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                               options connectionOptions: UIScene.ConnectionOptions) {
        SignalLifecycle.connectionOptions = connectionOptions
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    public override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { SignalLifecycle.receive($0.url) }
        super.scene(scene, openURLContexts: URLContexts)
    }
}

public class BytedanceAnalyticsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bytedance_analytics", binaryMessenger: registrar.messenger())
        let instance = BytedanceAnalyticsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion": result("iOS " + UIDevice.current.systemVersion)
        case "init": result(nil)
        case "start": SignalLifecycle.start(); result(nil)
        case "getClickId": result(SignalLifecycle.started ? BDASignalManager.getClickId() : nil)
        case "getIdfv": result(UIDevice.current.identifierForVendor?.uuidString)
        default: result(FlutterMethodNotImplemented)
        }
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        SignalLifecycle.launchOptions = launchOptions
        return false
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        SignalLifecycle.receive(url)
        return false
    }
}
