import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/ad_config.dart';

/// Home banner and a full-screen test ad after a cleared board.
class AdService {
  AdService._();

  static final AdService instance = AdService._();

  final ValueNotifier<BannerAd?> banner = ValueNotifier(null);
  InterstitialAd? _interstitial;
  bool _started = false;

  bool get enabled => !kIsWeb && !const bool.fromEnvironment('FLUTTER_TEST');

  void initialize() {
    if (_started || !enabled) return;
    _started = true;
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      await MobileAds.instance.initialize();
      _loadBanner();
      _loadInterstitial();
    } catch (error, stack) {
      debugPrint('ads init failed: $error\n$stack');
    }
  }

  void _loadBanner() {
    banner.value?.dispose();
    banner.value = null;
    BannerAd(
      adUnitId: AdConfig.banner,
      size: AdSize.banner,
      request: AdConfig.request,
      listener: BannerAdListener(
        onAdLoaded: (ad) => banner.value = ad as BannerAd,
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    ).load();
  }

  void _loadInterstitial() {
    if (_interstitial != null) return;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitial,
      request: AdConfig.request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) {},
      ),
    );
  }

  Future<void> showInterstitial() async {
    final ad = _interstitial;
    if (!enabled || ad == null) return;
    _interstitial = null;
    final done = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!done.isCompleted) done.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!done.isCompleted) done.complete();
      },
    );
    ad.show();
    await done.future;
    _loadInterstitial();
  }
}
