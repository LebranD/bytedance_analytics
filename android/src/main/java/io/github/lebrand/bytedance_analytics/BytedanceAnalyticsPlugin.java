package io.github.lebrand.bytedance_analytics;

import android.app.Activity;
import android.content.Context;
import android.provider.Settings;

import androidx.annotation.NonNull;

import com.bytedance.ads.convert.BDConvert;
import com.bytedance.applog.AppLog;
import com.bytedance.applog.InitConfig;
import com.bytedance.applog.util.UriConstants;

import java.util.Map;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** BytedanceAnalyticsPlugin */
public class BytedanceAnalyticsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private MethodChannel channel;
  private Context applicationContext;
  private Activity mainActivity;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bytedance_analytics");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.mainActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    this.mainActivity = null;
  }

  private void init(@NonNull MethodCall call, @NonNull Result result) {
    Map<String, Object> arguments = call.arguments();
    final String appId = (String) arguments.get("appId");
    final boolean enableImei = (boolean) arguments.get("enableImei");
    final boolean enableAutoTrack = (boolean) arguments.get("enableAutoTrack");
    final boolean enableLog = (boolean) arguments.get("enableLog");
    final boolean encryptAndCompress = (boolean) arguments.get("encryptAndCompress");
    final boolean enablePlay = (boolean) arguments.get("enablePlay");
    final boolean enableAutoStart = (boolean) arguments.get("enableAutoStart");

    /* 初始化SDK开始 */
    // 第一个参数APPID: 参考2.1节获取
    // 第二个参数CHANNEL: 填写渠道信息，请注意不能为空
    final InitConfig config = new InitConfig(appId, "toutiao");
    // 设置数据上送地址
    config.setUriConfig(UriConstants.DEFAULT);
    config.setImeiEnable(enableImei);//建议关停获取IMEI（出于合规考虑）
    config.setAutoTrackEnabled(enableAutoTrack); // 全埋点开关，true开启，false关闭
    config.setLogEnable(enableLog); // true:开启日志，参考4.3节设置logger，false:关闭日志
    AppLog.setEncryptAndCompress(encryptAndCompress); // 加密开关，true开启，false关闭
    config.setEnablePlay(enablePlay); // 配置心跳事件（时长统计）
    config.setAutoStart(enableAutoStart);
    //传入需要init的AppLog实例，若没有多个AppLog实例，则传入AppLog.getInstance()即可
    BDConvert.getInstance().init(this.applicationContext, AppLog.getInstance());
    AppLog.init(this.applicationContext, config, this.mainActivity);
    result.success(null);
  }

  private void start() {
    AppLog.start();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("init")) {
      init(call, result);
    } else if (call.method.equals("start")) {
      start();
      result.success(null);
    } else if (call.method.equals("getAndroidId")) {
      final String androidId = Settings.Secure.getString(applicationContext.getContentResolver(), Settings.Secure.ANDROID_ID);
      result.success(androidId);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    this.applicationContext = null;
  }
}
