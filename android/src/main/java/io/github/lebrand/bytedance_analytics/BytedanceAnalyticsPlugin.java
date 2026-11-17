package io.github.lebrand.bytedance_analytics;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bytedance.ads.convert.BDConvert;
import com.bytedance.ads.convert.callback.BDConvertLifecycleCallback;
import com.bytedance.ads.convert.config.BDConvertConfig;

import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BytedanceAnalyticsPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private static final String TAG = "BytedanceConvert";
  private static final AtomicBoolean initializationStarted = new AtomicBoolean(false);
  private final Handler mainHandler = new Handler(Looper.getMainLooper());
  private MethodChannel channel;
  private Context applicationContext;
  private Activity mainActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    applicationContext = binding.getApplicationContext();
    channel = new MethodChannel(binding.getBinaryMessenger(), "bytedance_analytics");
    channel.setMethodCallHandler(this);
  }

  @Override public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) { mainActivity = binding.getActivity(); }
  @Override public void onDetachedFromActivityForConfigChanges() { mainActivity = null; }
  @Override public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) { mainActivity = binding.getActivity(); }
  @Override public void onDetachedFromActivity() { mainActivity = null; }

  private void init(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    final Activity activity = mainActivity;
    final Context context = applicationContext;
    if (activity == null || context == null) {
      result.error("NO_ACTIVITY", "A foreground Activity is required for attribution initialization", null);
      return;
    }
    if (!initializationStarted.compareAndSet(false, true)) {
      result.success(null);
      return;
    }
    final BDConvertConfig config = new BDConvertConfig();
    config.setEnableLog(Boolean.TRUE.equals(call.argument("enableLog")));
    // Method A: initialize after consent and let the SDK send launch automatically.
    config.setAutoSendLaunchEvent(true);
    config.setLifecycleCallback(new BDConvertLifecycleCallback() {
      @Override public void onInitSuccess() { Log.i(TAG, "SDK initialization succeeded"); }
      @Override public void onInitFailure(int reason, @Nullable Throwable error) {
        initializationStarted.set(false);
        Log.e(TAG, "SDK initialization failed, reason=" + reason, error);
      }
      @Override public void onEventSendSuccess(@NonNull String eventName, @NonNull String requestId) {
        Log.i(TAG, "SDK event sent: " + eventName);
      }
      @Override public void onEventSendFailure(@NonNull String eventName, int reason, @NonNull String requestId, @Nullable Throwable error) {
        Log.e(TAG, "SDK event failed: " + eventName + ", reason=" + reason, error);
      }
      @Override public void onOtherError(int reason, @Nullable Throwable error) {
        Log.e(TAG, "SDK error, reason=" + reason, error);
      }
    });
    new Thread(() -> {
      try {
        BDConvert.INSTANCE.init(context, config, activity);
        mainHandler.post(() -> result.success(null));
      } catch (Exception error) {
        initializationStarted.set(false);
        Log.e(TAG, "SDK initialization threw", error);
        mainHandler.post(() -> result.error("INIT_FAILED", error.toString(), null));
      }
    }, "bytedance-convert-init").start();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "getPlatformVersion": result.success("Android " + android.os.Build.VERSION.RELEASE); break;
      case "init": init(call, result); break;
      // Android method A sends the launch event in init; avoid double counting.
      case "start": result.success(null); break;
      case "getAndroidId":
        result.success(Settings.Secure.getString(applicationContext.getContentResolver(), Settings.Secure.ANDROID_ID));
        break;
      default: result.notImplemented();
    }
  }

  @Override public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    applicationContext = null;
  }
}
