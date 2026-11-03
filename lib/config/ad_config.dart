import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google sample ads only. Real units wait until the Play app exists.
abstract final class AdConfig {
  static const String testAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitial = 'ca-app-pub-3940256099942544/1033173712';

  static const AdRequest request = AdRequest(nonPersonalizedAds: true);
}
