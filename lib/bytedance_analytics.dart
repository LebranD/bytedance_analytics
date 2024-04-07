
import 'bytedance_analytics_platform_interface.dart';

class BytedanceAnalytics {
  Future<String?> getPlatformVersion() {
    return BytedanceAnalyticsPlatform.instance.getPlatformVersion();
  }
}
