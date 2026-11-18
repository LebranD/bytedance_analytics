import {
  FlutterPlugin, FlutterPluginBinding, MethodCall, MethodCallHandler,
  MethodChannel, MethodResult
} from '@ohos/flutter_ohos';
import { BDConvert, BDConvertConfig } from '@bytedance_ads/app_convert';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { identifier } from '@kit.AdsKit';

export default class BytedanceAnalyticsPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private static initialized: boolean = false;
  private static started: boolean = false;

  getUniqueClassName(): string { return 'BytedanceAnalyticsPlugin'; }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'bytedance_analytics');
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(_binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null);
    this.channel = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method === 'init') {
      this.init(call, result);
    } else if (call.method === 'start') {
      if (!BytedanceAnalyticsPlugin.initialized) {
        result.error('not_initialized', 'Call init after privacy consent before start', null);
        return;
      }
      try {
        if (!BytedanceAnalyticsPlugin.started) {
          BDConvert.getInstance().sendLaunchEvent(getContext());
          BytedanceAnalyticsPlugin.started = true;
        }
        result.success(null);
      } catch (error) {
        result.error('start_failed', String(error), null);
      }
    } else if (call.method === 'getOaid') {
      this.getOaid(result);
    } else if (call.method === 'getPlatformVersion') {
      result.success('HarmonyOS');
    } else {
      result.notImplemented();
    }
  }

  private async requestTracking(): Promise<boolean> {
    try {
      const permission = await abilityAccessCtrl.createAtManager()
        .requestPermissionsFromUser(getContext(), ['ohos.permission.APP_TRACKING_CONSENT']);
      return permission.authResults[0] === 0;
    } catch (_) {
      return false;
    }
  }

  private async init(call: MethodCall, result: MethodResult): Promise<void> {
    if (BytedanceAnalyticsPlugin.initialized) {
      result.success(null);
      return;
    }
    const authorized = await this.requestTracking();
    if (BytedanceAnalyticsPlugin.initialized) {
      result.success(null);
      return;
    }
    try {
      const config = new BDConvertConfig();
      config.enableLog = call.argument('enableLog') as boolean;
      config.autoSendLaunchEvent = false;
      config.enablePlaySessionEvent = true;
      config.enableOAIDTrack = authorized;
      BDConvert.getInstance().init(getContext(), config);
      BytedanceAnalyticsPlugin.initialized = true;
      result.success(null);
    } catch (error) {
      result.error('init_failed', String(error), null);
    }
  }

  private async getOaid(result: MethodResult): Promise<void> {
    if (!await this.requestTracking()) {
      result.success(null);
      return;
    }
    try {
      result.success(await identifier.getOAID());
    } catch (error) {
      result.error('oaid_failed', String(error), null);
    }
  }
}
